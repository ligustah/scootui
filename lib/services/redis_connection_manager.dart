import 'dart:async';
import 'package:redis/redis.dart';

class RedisConnectionManager {
  final String host;
  final int port;
  final Function(String) onConnectionLost;
  final Function() onConnectionRestored;
  
  RedisConnection? _connection;
  Command? _command;
  PubSub? _pubsub;
  StreamSubscription? _subscription;
  bool _isDisposed = false;
  Timer? _reconnectTimer;
  bool _isReconnecting = false;
  Function(String, String)? _eventHandler;

  RedisConnectionManager({
    required this.host,
    required this.port,
    required this.onConnectionLost,
    required this.onConnectionRestored,
  });

  Command? get command => _command;

  Future<void> connect() async {
    if (_isDisposed) return;

    try {
      await cleanup();  // Clean up any existing connections
      
      // Create a new connection for commands
      final commandConnection = RedisConnection();
      _command = await commandConnection.connect(host, port);
      
      // Create a separate connection for PubSub
      final pubsubConnection = RedisConnection();
      final pubsubCommand = await pubsubConnection.connect(host, port);
      _pubsub = PubSub(pubsubCommand);
      
      _connection = commandConnection;
      
      if (_eventHandler != null) {
        await _setupSubscription(_eventHandler!);
      }
      
      _isReconnecting = false;
      
    } catch (e) {
      // print('Redis connection error: $e');
      await cleanup();
      rethrow;
    }
  }

  Future<void> _setupSubscription(Function(String, String) handler) async {
    if (_pubsub == null) return;

    try {
      // Subscribe to all relevant channels including both batteries
      _pubsub!.subscribe([
        "vehicle",
        "engine-ecu",
        "battery:0",
        "battery:1",
        "cb-battery",
        "aux-battery",
        "ble",
        "gps",
        "buttons" // Added button events channel for immediate button press notifications
      ]);
      
      // Set up stream listener
      final stream = _pubsub!.getStream();
      
      // Cancel any existing subscription
      await _subscription?.cancel();
      
      _subscription = stream.listen(
        (msg) {
          // Ensure msg is a List and has at least 3 elements
          if (msg is List && msg.length >= 3 && msg[0] == "message") {
            String channel = msg[1].toString();
            String message = msg[2].toString();
            // print('Redis message received: Channel=$channel, Message=$message');
            handler(channel, message);
          }
        },
        onError: (error) {
          // print('PubSub stream error: $error');
          handleConnectionLoss();
        },
        onDone: () {
          // print('PubSub stream closed');
          handleConnectionLoss();
        },
        cancelOnError: false,
      );
    } catch (e) {
      print('Error setting up PubSub listener: $e');
      handleConnectionLoss();
    }
  }

  void startEventListening(Function(String, String) eventHandler) {
    _eventHandler = eventHandler;
    if (_pubsub != null) {
      _setupSubscription(eventHandler);
    }
  }

  void handleConnectionLoss() {
    _command = null;  // Mark connection as lost
    onConnectionLost('Connection to MDB failed');
    cleanup();  // Clean up existing connections
    startReconnecting();  // Start reconnection process
  }

  void startReconnecting() {
    if (_isReconnecting || _isDisposed) return;
    
    _isReconnecting = true;
    _reconnectTimer?.cancel();
    
    // Attempt to reconnect every second
    _reconnectTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isDisposed || !_isReconnecting) {
        timer.cancel();
        return;
      }

      try {
        await connect();  // This will create new connections and resubscribe
        timer.cancel();
        _isReconnecting = false;
        onConnectionRestored();
      } catch (e) {
        print('Reconnection attempt failed: $e');
        // Keep trying - timer will trigger again
      }
    });
  }

  Future<void> cleanup() async {
    try {
      await _subscription?.cancel();
      _subscription = null;
      
      if (_command != null) {
        await _command!.get_connection().close();
        _command = null;
      }
      if (_pubsub != null) {
        _pubsub = null;
      }
      if (_connection != null) {
        _connection = null;
      }
    } catch (e) {
      print('Error cleaning up connection: $e');
    }
  }

  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    cleanup();
  }
}