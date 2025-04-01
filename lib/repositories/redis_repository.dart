import 'dart:async';

import 'package:redis/redis.dart';

class RedisRepository {
  final String host;
  final int port;

  RedisRepository({required this.host, required this.port});

  Future<void> dashboardReady() async {
    final cmd = await connect();
    await cmd.send_object(["HSET", "dashboard", "ready", "true"]);
    await cmd.send_object(["PUBLISH", "dashboard", "ready"]);
  }

  // TODO: create simple connection pool
  // TODO: add function here to query state (to fully encapsulate redis logic)
  // TODO: determine redis host based on platform

  Future<Command> connect() async {
    final con = RedisConnection();
    return await con.connect(host, port);
  }

  Stream<(String, String)> subscribe(String channel) async* {
    final cmd = await connect();

    final ps = PubSub(cmd);
    ps.subscribe([channel]);

    try {
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
    } finally {
      await cmd.get_connection().close();
    }
  }
}
