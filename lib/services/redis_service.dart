import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:redis/redis.dart';
import '../models/vehicle_state.dart';
import 'redis_connection_manager.dart';
import 'redis_state_fetcher.dart';
import 'redis_event_handler.dart';

class RedisService {
  final String host;
  final int port;
  final VehicleState vehicleState;
  bool _isDisposed = false;
  Timer? _pollTimer;

  // Connection manager
  late final RedisConnectionManager _connectionManager;
  
  // State fetcher
  late final RedisStateFetcher _stateFetcher;
  
  // Event handler
  late final RedisEventHandler _eventHandler;

  // Returns the appropriate Redis host based on the platform
  static String getRedisHost() {
    if (Platform.isMacOS || Platform.isWindows) {
      return '127.0.0.1';  // Local development
    }
    return '192.168.7.1';  // Target system
  }

  // Factory constructor that determines the correct host
  factory RedisService(
    String _, // Host parameter is ignored and determined by platform
    int port,
    VehicleState vehicleState, {
    Function(String)? onConnectionLost,
    Function()? onConnectionRestored,
    Function(ThemeMode)? onThemeSwitch,
    Function(String)? onBatteryAlert,
    Function(String, String)? onBrakeEvent,
    Function(String?)? onBluetoothPinCodeEvent,
  }) {
    return RedisService._internal(
      getRedisHost(),
      port,
      vehicleState,
      onConnectionLost: onConnectionLost,
      onConnectionRestored: onConnectionRestored,
      onThemeSwitch: onThemeSwitch,
      onBatteryAlert: onBatteryAlert,
      onBrakeEvent: onBrakeEvent,
      onBluetoothPinCodeEvent: onBluetoothPinCodeEvent,
    );
  }

  // Internal constructor
  RedisService._internal(
    this.host, 
    this.port, 
    this.vehicleState, {
    this.onConnectionLost,
    this.onConnectionRestored,
    this.onThemeSwitch,
    this.onBatteryAlert,
    this.onBrakeEvent,
    this.onBluetoothPinCodeEvent,
  }) {
    _connectionManager = RedisConnectionManager(
      host: host,
      port: port,
      onConnectionLost: (message) {
        _stopPolling();
        onConnectionLost?.call('Connection to MDB failed');
      },
      onConnectionRestored: () {
        onConnectionRestored?.call();
        _startPolling();
      },
    );

    _stateFetcher = RedisStateFetcher(
      vehicleState: vehicleState,
      getCommand: () => _connectionManager.command,
    );

    _eventHandler = RedisEventHandler(
      vehicleState: vehicleState,
      onThemeSwitch: onThemeSwitch,
      onBatteryAlert: onBatteryAlert,
      onBluetoothPinCodeEvent: onBluetoothPinCodeEvent,
    );
  }

  // Callback for connection status changes
  final Function(String)? onConnectionLost;
  final Function()? onConnectionRestored;

  // Theme switching callback
  final Function(ThemeMode)? onThemeSwitch;
  
  // Battery alert callback
  final Function(String)? onBatteryAlert;
  
  // Brake event callback
  final Function(String, String)? onBrakeEvent;

  // Bluetooth pin code event callback
  final Function(String?)? onBluetoothPinCodeEvent;

  Future<void> connect() async {
    if (_isDisposed) return;

    try {
      await _connectionManager.connect();
      
      // Start listening to vehicle events
      _connectionManager.startEventListening((channel, key) async {
        await _handleRedisEvent(channel, key);
      });
      
      print('Successfully connected to Redis on $host:$port');
      
      // Send readiness indication to MDB
      await _connectionManager.command?.send_object(["HSET", "dashboard", "ready", "true"]);
      await _connectionManager.command?.send_object(["PUBLISH", "dashboard", "ready"]);
      
      await _stateFetcher.fetchInitialState();
      _startPolling();
    } catch (e) {
      print('Redis connection error: $e');
      onConnectionLost?.call('Connection to MDB failed');
      await _connectionManager.cleanup();
      rethrow;
    }
  }

  Future<void> _handleRedisEvent(String channel, String key) async {
    if (channel == 'battery:0' || channel == 'battery:1') {
      print('Battery event: $channel $key');
      final value = await _connectionManager.command?.send_object(["HGET", channel, key]);
      if (value != null) {
        vehicleState.updateFromRedis(channel, key, value);
        _eventHandler.handleEvent(key);
      }
    } else if (channel == 'vehicle' && key.startsWith('brake:')) {
      print('Brake event: $key');
      final state = await _connectionManager.command?.send_object(["HGET", "vehicle", key]);
      if (state != null) {
        print('Brake state: $state');
        vehicleState.updateFromRedis('vehicle', key, state);
        _eventHandler.handleBrakeEvent(key, state);
        onBrakeEvent?.call(key, state);
      }
    } else if (channel == 'ble') {
      // Handle BLE events
      print('BLE event: $key');
      final value = await _connectionManager.command?.send_object(["HGET", "ble", key]);
      
      if (value != null) {
        // Update vehicle state for BLE events
        vehicleState.updateFromRedis(channel, key, value);
        
        // Handle specific BLE events
        if (key == 'status') {
          print('BLE status: $value');
        } else if (key == 'pin-code') {
          print('BLE pin code: $value');
          onBluetoothPinCodeEvent?.call(value);
        }
      } else {
        // Handle case when value is null (e.g., pin code cleared)
        if (key == 'pin-code') {
          print('BLE pin code cleared');
          onBluetoothPinCodeEvent?.call(null);
        }
      }
    } else {
      print('Other event: $channel $key');
      final value = await _connectionManager.command?.send_object(["HGET", channel, key]);
      if (value != null) {
        vehicleState.updateFromRedis(channel, key, value);
        _eventHandler.handleEvent(key);
      }
    }
  }

  void _startPolling() {
    _stopPolling();
    // Poll every 100ms to match the update frequency in the MDB
    _pollTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_isDisposed) {
        _stateFetcher.fetchInitialState().catchError((error) {
          print('Lost connection to Redis: $error');
          if (error.toString().contains('StreamSink is closed')) {
            _connectionManager.handleConnectionLoss();
          }
        });
      }
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void dispose() {
    _isDisposed = true;
    _stopPolling();
    _connectionManager.dispose();
  }

  Future<void> toggleHazardLights() async {
    final blinkerState = await _connectionManager.command?.send_object(["HGET", "vehicle", "blinker:state"]);
    if (blinkerState != 'both') {
      await _connectionManager.command?.send_object(["LPUSH", "scooter:blinker", "both"]);
    } else {
      await _connectionManager.command?.send_object(["LPUSH", "scooter:blinker", "off"]);
    }
  }
}