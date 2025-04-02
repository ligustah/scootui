import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:redis/redis.dart';

import 'mdb_repository.dart';

class ConnectionPool {
  final String host;
  final int port;
  final int maxConnections;
  final List<Command> _connections = [];
  final List<Completer<Command>> _waitingQueue = [];
  int _activeConnections = 0;
  Timer? _healthCheckTimer;
  final Duration _healthCheckInterval = const Duration(seconds: 10);

  ConnectionPool({
    required this.host,
    required this.port,
    this.maxConnections = 50,
  }) {
    _startHealthCheck();
  }

  void _startHealthCheck() {
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (_) {
      _checkConnections();
    });
  }

  Future<void> _checkConnections() async {
    if (_connections.isEmpty) return;

    final List<Command> validConnections = [];

    for (final cmd in List.from(_connections)) {
      try {
        // Use PING command to check if connection is still alive
        final result = await cmd.send_object(["PING"]);
        if (result == "PONG") {
          validConnections.add(cmd);
        } else {
          _activeConnections--;
        }
      } catch (e) {
        cmd.get_connection().close();
        _activeConnections--;
        // Connection is invalid, discard it
      }
    }

    _connections
      ..clear()
      ..addAll(validConnections);
  }

  Future<Command> getConnection() async {
    // If there's an available connection, return it immediately
    if (_connections.isNotEmpty) {
      return _connections.removeLast();
    }

    // If we haven't reached max connections yet, create a new one
    if (_activeConnections < maxConnections) {
      _activeConnections++;
      final con = RedisConnection();
      return await con.connect(host, port);
    }

    // If we reached here, we need to wait for a connection to be released
    final completer = Completer<Command>();
    _waitingQueue.add(completer);
    return completer.future;
  }

  void releaseConnection(Command cmd) {
    // If someone is waiting for a connection, give it to them directly
    if (_waitingQueue.isNotEmpty) {
      final completer = _waitingQueue.removeAt(0);
      completer.complete(cmd);
      return;
    }

    // Otherwise, return it to the pool
    _connections.add(cmd);
  }

  Future<void> dispose() async {
    _healthCheckTimer?.cancel();

    // Close all connections in the pool
    for (final cmd in _connections) {
      try {
        await cmd.get_connection().close();
      } catch (_) {
        // Ignore errors during disposal
      }
    }
    _connections.clear();
    _activeConnections = 0;
  }
}

class RedisMDBRepository implements MDBRepository {
  final ConnectionPool _pool;

  static String getRedisHost() {
    if (Platform.isMacOS || Platform.isWindows) {
      return '127.0.0.1'; // Local development
    }
    return '192.168.7.1'; // Target system
  }

  static MDBRepository create(BuildContext context) {
    return RedisMDBRepository(host: getRedisHost(), port: 6379)
      ..dashboardReady();
  }

  RedisMDBRepository({required String host, required int port})
      : _pool = ConnectionPool(host: host, port: port);

  Future<T> _withConnection<T>(Future<T> Function(Command) action) async {
    Command? cmd;
    try {
      cmd = await _pool.getConnection();
      return await action(cmd);
    } finally {
      if (cmd != null) {
        _pool.releaseConnection(cmd);
      }
    }
  }

  Stream<T> _withConnectionStream<T>(
      Stream<T> Function(Command) action) async* {
    Command? cmd;
    try {
      cmd = await _pool.getConnection();
      yield* action(cmd);
    } finally {
      if (cmd != null) {
        _pool.releaseConnection(cmd);
      }
    }
  }

  Future<void> dashboardReady() => set("dashboard", "ready", "true");

  Future<void> set(String cluster, String variable, String value,
      {bool publish = true}) {
    return _withConnection((cmd) async {
      await cmd.send_object(["HSET", cluster, variable, value]);
      if (publish) {
        await cmd.send_object(["PUBLISH", cluster, variable]);
      }
    });
  }

  Future<List<(String, String)>> getAll(String cluster) {
    return _withConnection((cmd) async {
      final result = await cmd.send_object(["HGETALL", cluster]);
      final List<(String, String)> values = [];

      if (result is List) {
        for (int i = 0; i < result.length; i += 2) {
          final key = result[i].toString();
          final value = result[i + 1].toString();
          values.add((key, value));
        }
      }

      return values;
    });
  }

  Future<String?> get(String cluster, String variable) {
    return _withConnection((cmd) async {
      final result = await cmd.send_object(["HGET", cluster, variable]);
      if (result is String) {
        return result;
      }

      return null;
    });
  }

  Stream<(String, String)> subscribe(String channel) {
    return _withConnectionStream((cmd) async* {
      final ps = PubSub(cmd);
      ps.subscribe([channel]);

      yield* ps
          .getStream()
          .map((msg) {
            if (msg is List && msg.length >= 3 && msg[0] == 'message') {
              return (msg[1].toString(), msg[2].toString());
            }
            return null;
          })
          .where((result) => result != null)
          .map((rec) => rec!);
    });
  }

  Future<void> dispose() async {
    await _pool.dispose();
  }
}
