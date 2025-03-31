import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scooter_cluster/screens/main_screen.dart';

import '../services/redis_connection_manager.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  late RedisConnectionManager _redis;
  int _simulatedSpeed = 0;
  int _simulatedRpm = 0;
  int _simulatedBatteryCharge0 = 100;
  int _simulatedBatteryCharge1 = 100;
  String? _errorMessage;
  bool _battery0Present = true;
  bool _battery1Present = true;
  Timer? _brakeDoubleTapTimer;

  @override
  void initState() {
    super.initState();
    _setupRedis();
  }

  void _setupRedis() {
    _redis = RedisConnectionManager(
      host: '',  // Host is determined by platform
      port: 6379,  // Default Redis port
      onConnectionLost: (message) {
        setState(() {
          _errorMessage = message;
        });
      },
      onConnectionRestored: () {
        setState(() {
          _errorMessage = null;
        });
      },
    );
    _connectToRedis();
  }

  Future<void> _connectToRedis() async {
    try {
      await _redis.connect();
      setState(() {
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('Failed to connect to Redis: $e');
      setState(() {
        _errorMessage = 'Connection to MDB failed';
      });
    }
  }

  Future<void> _updateEngineValues() async {
    final futures = [
      _publishEvent('engine-ecu', 'speed', _simulatedSpeed.toString()),
      _publishEvent('engine-ecu', 'rpm', _simulatedRpm.toString()),
    ];
    await Future.wait(futures);
  }

  Future<void> _updateBatteryValues() async {
    final futures = [
      _publishEvent('battery:0', 'present', _battery0Present.toString()),
      _publishEvent('battery:1', 'present', _battery1Present.toString()),
      if (_battery0Present)
        _publishEvent('battery:0', 'charge', _simulatedBatteryCharge0.toString()),
      if (_battery1Present)
        _publishEvent('battery:1', 'charge', _simulatedBatteryCharge1.toString()),
    ];
    await Future.wait(futures);
  }

  Future<void> _publishEvent(String channel, String key, String value) {
    final command = _redis.command;
    if (command == null) return Future.value();

    return Future.wait([
      command.send_object(['HSET', channel, key, value]),
      command.send_object(['PUBLISH', channel, key]),
    ]);
  }

  Future<void> _simulateBrakeDoubleTap() async {
    // First press
    await _publishEvent('engine-ecu', 'brake:left', 'on');
    await _publishEvent('vehicle', 'brake:left', 'on');
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // First release
    await _publishEvent('engine-ecu', 'brake:left', 'off');
    await _publishEvent('vehicle', 'brake:left', 'off');
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Second press
    await _publishEvent('engine-ecu', 'brake:left', 'on');
    await _publishEvent('vehicle', 'brake:left', 'on');
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Second release
    await _publishEvent('engine-ecu', 'brake:left', 'off');
    await _publishEvent('vehicle', 'brake:left', 'off');
  }

  @override
  void dispose() {
    _brakeDoubleTapTimer?.cancel();
    _redis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cluster Simulator'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  'Speed & RPM',
                  [
                    _buildSlider(
                      'Speed (km/h)',
                      _simulatedSpeed,
                      0,
                      100,
                      (value) {
                        setState(() => _simulatedSpeed = value.toInt());
                        _updateEngineValues();
                      },
                    ),
                    _buildSlider(
                      'RPM',
                      _simulatedRpm,
                      0,
                      10000,
                      (value) {
                        setState(() => _simulatedRpm = value.toInt());
                        _updateEngineValues();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  'Battery States',
                  [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Battery 0'),
                                  const SizedBox(width: 8),
                                  Checkbox(
                                    value: _battery0Present,
                                    onChanged: (value) {
                                      setState(() => _battery0Present = value ?? false);
                                      _updateBatteryValues();
                                    },
                                  ),
                                ],
                              ),
                              if (_battery0Present)
                                _buildSlider(
                                  'Charge (%)',
                                  _simulatedBatteryCharge0,
                                  0,
                                  100,
                                  (value) {
                                    setState(() => _simulatedBatteryCharge0 = value.toInt());
                                    _updateBatteryValues();
                                  },
                                ),
                              _buildButtonGroup(
                                'State',
                                ['unknown', 'charging', 'discharging', 'idle'],
                                (value) => _publishEvent('battery:0', 'state', value),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Battery 1'),
                                  const SizedBox(width: 8),
                                  Checkbox(
                                    value: _battery1Present,
                                    onChanged: (value) {
                                      setState(() => _battery1Present = value ?? false);
                                      _updateBatteryValues();
                                    },
                                  ),
                                ],
                              ),
                              if (_battery1Present)
                                _buildSlider(
                                  'Charge (%)',
                                  _simulatedBatteryCharge1,
                                  0,
                                  100,
                                  (value) {
                                    setState(() => _simulatedBatteryCharge1 = value.toInt());
                                    _updateBatteryValues();
                                  },
                                ),
                              _buildButtonGroup(
                                'State',
                                ['unknown', 'charging', 'discharging', 'idle'],
                                (value) => _publishEvent('battery:1', 'state', value),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSection(
                        'Vehicle States',
                        [
                          _buildButtonGroup(
                            'Blinker State',
                            ['off', 'left', 'right', 'both'],
                            (value) => _publishEvent('vehicle', 'blinker:state', value),
                          ),
                          _buildButtonGroup(
                            'Handlebar Position',
                            ['unlocked', 'locked'],
                            (value) => _publishEvent('vehicle', 'handlebar:position', value),
                          ),
                          _buildButtonGroup(
                            'Kickstand State',
                            ['up', 'down'],
                            (value) => _publishEvent('vehicle', 'kickstand', value),
                          ),
                          _buildButtonGroup(
                            'Vehicle State',
                            ['parked', 'running', 'error'],
                            (value) => _publishEvent('vehicle', 'state', value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSection(
                        'Brake States',
                        [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildButtonGroup(
                                'Left Brake',
                                ['off', 'on', 'double-tap'],
                                (value) {
                                  if (value == 'double-tap') {
                                    _simulateBrakeDoubleTap();
                                  } else {
                                    _publishEvent('engine-ecu', 'brake:left', value);
                                    _publishEvent('vehicle', 'brake:left', value);
                                  }
                                },
                              ),
                            ],
                          ),
                          _buildButtonGroup(
                            'Right Brake',
                            ['off', 'on'],
                            (value) {
                              _publishEvent('engine-ecu', 'brake:right', value);
                              _publishEvent('vehicle', 'brake:right', value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSection(
                        'System States',
                        [
                          _buildButtonGroup(
                            'Bluetooth Connection',
                            ['disconnected', 'connected'],
                            (value) => _publishEvent('ble', 'status', value),
                          ),
                          _buildButtonGroup(
                            'Internet Connection',
                            ['disconnected', 'connected'],
                            (value) => _publishEvent('internet', 'status', value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildSection("Screen", [MainScreen()])
              ],
            ),
          ),
          if (_errorMessage != null)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.red.withOpacity(0.8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    int value,
    int min,
    int max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: (max - min).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildButtonGroup(
    String label,
    List<String> options,
    ValueChanged<String> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            return ElevatedButton(
              onPressed: () => onSelected(option),
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
} 