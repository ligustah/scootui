import 'dart:async';

import 'package:flutter/material.dart';

import '../repositories/mdb_repository.dart';
import 'main_screen.dart';

class SimulatorScreen extends StatefulWidget {
  final MDBRepository repository;

  const SimulatorScreen({
    super.key,
    required this.repository,
  });

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  int _simulatedSpeed = 0;
  int _simulatedRpm = 0;
  int _simulatedBatteryCharge0 = 100;
  int _simulatedBatteryCharge1 = 100;
  int _signalQuality = 0;
  String? _errorMessage;
  bool _battery0Present = true;
  bool _battery1Present = true;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  Future<void> _initializeValues() async {
    // Initialize engine values
    await _updateEngineValues();

    // Initialize battery values
    await _updateBatteryValues();

    // Initialize vehicle states
    await Future.wait([
      _publishEvent('vehicle', 'blinker:state', 'off'),
      _publishEvent('vehicle', 'handlebar:position', 'unlocked'),
      _publishEvent('vehicle', 'handlebar:lock-sensor', 'unlocked'),
      _publishEvent('vehicle', 'kickstand', 'up'),
      _publishEvent('vehicle', 'state', 'parked'),
      _publishEvent('vehicle', 'brake:left', 'off'),
      _publishEvent('vehicle', 'brake:right', 'off'),
    ]);

    // Initialize system states
    await Future.wait([
      _publishEvent('ble', 'status', 'disconnected'),
      _publishEvent('internet', 'modem-state', 'disconnected'),
      _publishEvent('ota', 'status', 'unknown'),
    ]);
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
      if (_battery0Present) _publishEvent('battery:0', 'charge', _simulatedBatteryCharge0.toString()),
      if (_battery1Present) _publishEvent('battery:1', 'charge', _simulatedBatteryCharge1.toString()),
    ];
    await Future.wait(futures);
  }

  Future<void> _publishEvent(String channel, String key, String value) async {
    await widget.repository.set(channel, key, value);
  }

  Future<void> _simulateBrakeDoubleTap(String brake) async {
    // First press
    await _publishEvent('vehicle', 'brake:$brake', 'on');

    await Future.delayed(const Duration(milliseconds: 100));

    // First release
    await _publishEvent('vehicle', 'brake:$brake', 'off');

    await Future.delayed(const Duration(milliseconds: 100));

    // Second press
    await _publishEvent('vehicle', 'brake:$brake', 'on');
    await Future.delayed(const Duration(milliseconds: 100));

    // Second release
    await _publishEvent('vehicle', 'brake:$brake', 'off');
  }

  Future<void> _simulateBrakeTap(String brake) async {
    // Press
    await _publishEvent('vehicle', 'brake:$brake', 'on');

    await Future.delayed(const Duration(milliseconds: 100));

    // Release
    await _publishEvent('vehicle', 'brake:$brake', 'off');
  }

  @override
  void dispose() {
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
                // Top row with simulator screen and controls
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 480 + 32,
                      height: 560,
                      child: _buildSection("Screen", [MainScreen()]),
                    ),
                    // Right side - Speed, RPM, and Battery controls
                    Expanded(
                      child: Column(
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
                                          ['unknown', 'asleep', 'active', 'idle'],
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
                                          ['unknown', 'asleep', 'active', 'idle'],
                                          (value) => _publishEvent('battery:1', 'state', value),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Bottom row with remaining controls
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
                            ['stand-by', 'ready-to-drive', 'parked', 'off'],
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
                                ['off', 'on', 'tap', 'double-tap'],
                                (value) {
                                  switch (value) {
                                    case 'double-tap':
                                      _simulateBrakeDoubleTap('left');
                                      break;
                                    case 'tap':
                                      _simulateBrakeTap('left');
                                      break;
                                    default:
                                      _publishEvent('vehicle', 'brake:left', value);
                                  }
                                },
                              ),
                            ],
                          ),
                          _buildButtonGroup(
                            'Right Brake',
                            ['off', 'on', 'tap', 'double-tap'],
                            (value) {
                              switch (value) {
                                case 'double-tap':
                                  _simulateBrakeDoubleTap('right');
                                  break;
                                case 'tap':
                                  _simulateBrakeTap('right');
                                  break;
                                default:
                                  _publishEvent('vehicle', 'brake:right', value);
                              }
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
                            'Internet status',
                            ['disconnected', 'connected'],
                            (value) => _publishEvent('internet', 'status', value),
                          ),
                          _buildSlider('Signal Quality', _signalQuality, 0, 100, (value) {
                            setState(() => _signalQuality = value.toInt());
                            _publishEvent('internet', 'signal-quality', value.toInt().toString());
                          }),
                          _buildButtonGroup('Cloud Status', ['disconnected', 'connected'],
                              (value) => _publishEvent('internet', 'unu-cloud', value)),
                          _buildButtonGroup('GPS Status', ['off', 'searching', 'fix-established', 'error'],
                              (value) => _publishEvent('gps', 'state', value)),

                          // OTA Update Status Controls
                          _buildButtonGroup(
                            'OTA Status',
                            [
                              'none',
                              'initializing',
                              'checking-updates',
                              'checking-update-error',
                              'device-updated',
                              'waiting-dashboard',
                              'downloading-updates',
                              'downloading-update-error',
                              'installing-updates',
                              'installing-update-error',
                              'installation-complete-waiting-dashboard-reboot',
                              'installation-complete-waiting-reboot',
                              'unknown'
                            ],
                            (value) => _publishEvent('ota', 'status', value),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
