import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class MDBRepository {
  Future<String?> get(String channel, String variable);

  Future<List<(String, String)>> getAll(String channel);

  Future<void> set(String channel, String variable, String value,
      {bool publish = true});

  Stream<(String, String)> subscribe(String channel);
}

class InMemoryMDBRepository implements MDBRepository {
  static MDBRepository create(BuildContext context) {
    return InMemoryMDBRepository();
  }

  final Map<String, Map<String, String>> _storage = {};
  final Map<String, List<StreamController<(String, String)>>> _subscribers = {};

  @override
  Future<String?> get(String channel, String variable) async {
    return _storage[channel]?[variable];
  }

  @override
  Future<List<(String, String)>> getAll(String channel) async {
    final channelData = _storage[channel] ?? {};
    return channelData.entries.map((e) => (e.key, e.value)).toList();
  }

  @override
  Future<void> set(String channel, String variable, String value,
      {bool publish = true}) async {
    _storage.putIfAbsent(channel, () => {});
    _storage[channel]![variable] = value;

    if (publish) {
      // Notify subscribers
      if (_subscribers.containsKey(channel)) {
        for (var controller in _subscribers[channel]!) {
          controller.add((channel, variable));
        }
      }
    }
  }

  @override
  Stream<(String, String)> subscribe(String channel) {
    final controller = StreamController<(String, String)>();

    _subscribers.putIfAbsent(channel, () => []);
    _subscribers[channel]!.add(controller);

    controller.onCancel = () {
      _subscribers[channel]?.remove(controller);
      if (_subscribers[channel]?.isEmpty ?? false) {
        _subscribers.remove(channel);
      }
    };

    return controller.stream;
  }

  Future<void> dispose() async {
    for (var controllers in _subscribers.values) {
      for (var controller in controllers) {
        await controller.close();
      }
    }
    _subscribers.clear();
  }
}
