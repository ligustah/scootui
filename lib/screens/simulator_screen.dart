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
  // Engine values
  int _simulatedSpeed = 0;
  int _simulatedRpm = 0;
  int _simulatedMotorCurrent = 0;
  double _simulatedOdometer = 0.0;

  // Battery values
  int _simulatedBatteryCharge0 = 100;
  int _simulatedBatteryCharge1 = 100;
  bool _battery0Present = true;
  bool _battery1Present = true;

  // System values
  int _signalQuality = 0;
  String? _errorMessage;

  // Current states
  String _blinkerState = 'off';
  String _handlebarPosition = 'unlocked';
  String _kickstandState = 'up';
  String _vehicleState = 'parked';
  String _leftBrakeState = 'off';
  String _rightBrakeState = 'off';
  String _seatboxButtonState = 'off';
  String _bluetoothStatus = 'disconnected';
  String _internetStatus = 'disconnected';
  String _cloudStatus = 'disconnected';
  String _gpsState = 'off';
  String _otaStatus = 'none';
  String _dbcStatus = '';
  String _mdbStatus = '';
  String _updateType = 'none';

  // Battery states
  String _battery0State = 'unknown';
  String _battery1State = 'unknown';

  // Expanded sections
  bool _vehicleStateExpanded = false;
  bool _otaStatusExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    // Load current values from Redis
    await _loadCurrentValues();

    // Initialize values if not already set
    await _initializeValues();
  }

  Future<void> _loadCurrentValues() async {
    try {
      // Load vehicle states
      final blinkerState = await widget.repository.get('vehicle', 'blinker:state');
      final handlebarPosition = await widget.repository.get('vehicle', 'handlebar:position');
      final kickstandState = await widget.repository.get('vehicle', 'kickstand');
      final vehicleState = await widget.repository.get('vehicle', 'state');
      final leftBrakeState = await widget.repository.get('vehicle', 'brake:left');
      final rightBrakeState = await widget.repository.get('vehicle', 'brake:right');

      // Load system states
      final bluetoothStatus = await widget.repository.get('ble', 'status');
      final internetStatus = await widget.repository.get('internet', 'status');
      final signalQuality = await widget.repository.get('internet', 'signal-quality');
      final cloudStatus = await widget.repository.get('internet', 'unu-cloud');
      final gpsState = await widget.repository.get('gps', 'state');
      final otaStatus = await widget.repository.get('ota', 'status');
      final dbcStatus = await widget.repository.get('ota', 'status:dbc');
      final mdbStatus = await widget.repository.get('ota', 'status:mdb');
      final updateType = await widget.repository.get('ota', 'update-type');

      // Load battery states
      final battery0Present = await widget.repository.get('battery:0', 'present');
      final battery0Charge = await widget.repository.get('battery:0', 'charge');
      final battery0State = await widget.repository.get('battery:0', 'state');

      final battery1Present = await widget.repository.get('battery:1', 'present');
      final battery1Charge = await widget.repository.get('battery:1', 'charge');
      final battery1State = await widget.repository.get('battery:1', 'state');

      // Load engine values
      final speed = await widget.repository.get('engine-ecu', 'speed');
      final rpm = await widget.repository.get('engine-ecu', 'rpm');
      final odometer = await widget.repository.get('engine-ecu', 'odometer');

      // Update state with loaded values
      setState(() {
        if (blinkerState != null) _blinkerState = blinkerState;
        if (handlebarPosition != null) _handlebarPosition = handlebarPosition;
        if (kickstandState != null) _kickstandState = kickstandState;
        if (vehicleState != null) _vehicleState = vehicleState;
        if (leftBrakeState != null) _leftBrakeState = leftBrakeState;
        if (rightBrakeState != null) _rightBrakeState = rightBrakeState;

        if (bluetoothStatus != null) _bluetoothStatus = bluetoothStatus;
        if (internetStatus != null) _internetStatus = internetStatus;
        if (signalQuality != null) _signalQuality = int.tryParse(signalQuality) ?? 0;
        if (cloudStatus != null) _cloudStatus = cloudStatus;
        if (gpsState != null) _gpsState = gpsState;
        if (otaStatus != null) _otaStatus = otaStatus;
        if (dbcStatus != null) _dbcStatus = dbcStatus;
        if (mdbStatus != null) _mdbStatus = mdbStatus;
        if (updateType != null) _updateType = updateType;

        if (battery0Present != null) _battery0Present = battery0Present.toLowerCase() == 'true';
        if (battery0Charge != null) _simulatedBatteryCharge0 = int.tryParse(battery0Charge) ?? 100;
        if (battery0State != null) _battery0State = battery0State;

        if (battery1Present != null) _battery1Present = battery1Present.toLowerCase() == 'true';
        if (battery1Charge != null) _simulatedBatteryCharge1 = int.tryParse(battery1Charge) ?? 100;
        if (battery1State != null) _battery1State = battery1State;

        if (speed != null) _simulatedSpeed = int.tryParse(speed) ?? 0;
        if (rpm != null) _simulatedRpm = int.tryParse(rpm) ?? 0;
        if (odometer != null) {
          final odometerValue = double.tryParse(odometer) ?? 0.0;
          _simulatedOdometer = odometerValue / 1000.0; // Convert from meters to km
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading values: $e';
      });
    }
  }

  Future<void> _initializeValues() async {
    // Initialize engine values
    await _updateEngineValues();

    // Initialize battery values
    await _updateBatteryValues();

    // Initialize vehicle states if not already set
    await Future.wait([
      _publishEvent('vehicle', 'blinker:state', _blinkerState),
      _publishEvent('vehicle', 'handlebar:position', _handlebarPosition),
      _publishEvent('vehicle', 'handlebar:lock-sensor', _handlebarPosition),
      _publishEvent('vehicle', 'kickstand', _kickstandState),
      _publishEvent('vehicle', 'state', _vehicleState),
      _publishEvent('vehicle', 'brake:left', _leftBrakeState),
      _publishEvent('vehicle', 'brake:right', _rightBrakeState),
      _publishEvent('vehicle', 'seatbox:button', _seatboxButtonState),
    ]);

    // Initialize system states if not already set
    await Future.wait([
      _publishEvent('ble', 'status', _bluetoothStatus),
      _publishEvent('internet', 'modem-state', _internetStatus),
      _publishEvent('internet', 'status', _internetStatus),
      _publishEvent('internet', 'signal-quality', _signalQuality.toString()),
      _publishEvent('internet', 'unu-cloud', _cloudStatus),
      _publishEvent('gps', 'state', _gpsState),
      _publishEvent('ota', 'status', _otaStatus),
    ]);
  }

  Future<void> _updateEngineValues() async {
    final futures = [
      _publishEvent('engine-ecu', 'speed', _simulatedSpeed.toString()),
      _publishEvent('engine-ecu', 'rpm', _simulatedRpm.toString()),
      _publishEvent('engine-ecu', 'motor:current', (_simulatedMotorCurrent * 1000).toString()),
      _publishEvent('engine-ecu', 'odometer', (_simulatedOdometer * 1000).toString()),
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

  // Button press/release methods
  Future<void> _seatboxButtonDown() async {
    print('Seatbox button DOWN');
    setState(() => _seatboxButtonState = 'on');
    // Update the hash state
    await _publishEvent('vehicle', 'seatbox:button', 'on');
    // Also publish a direct button event
    await _publishButtonEvent('seatbox:on');
  }

  Future<void> _seatboxButtonUp() async {
    print('Seatbox button UP');
    setState(() => _seatboxButtonState = 'off');
    // Update the hash state
    await _publishEvent('vehicle', 'seatbox:button', 'off');
    // Also publish a direct button event
    await _publishButtonEvent('seatbox:off');
  }

  // Helper method to publish a button event via PUBSUB
  Future<void> _publishButtonEvent(String event) async {
    try {
      await widget.repository.publishButtonEvent(event);
      print('Published button event: $event');
    } catch (e) {
      print('Error publishing button event: $e');
    }
  }

  Future<void> _simulateBrakeDoubleTap(String brake) async {
    // First press
    await _publishEvent('vehicle', 'brake:$brake', 'on');
    await _publishButtonEvent('brake:$brake:on');

    await Future.delayed(const Duration(milliseconds: 100));

    // First release
    await _publishEvent('vehicle', 'brake:$brake', 'off');
    await _publishButtonEvent('brake:$brake:off');

    await Future.delayed(const Duration(milliseconds: 100));

    // Second press
    await _publishEvent('vehicle', 'brake:$brake', 'on');
    await _publishButtonEvent('brake:$brake:on');

    await Future.delayed(const Duration(milliseconds: 100));

    // Second release
    await _publishEvent('vehicle', 'brake:$brake', 'off');
    await _publishButtonEvent('brake:$brake:off');
  }

  Future<void> _simulateBrakeTap(String brake) async {
    // Press
    await _publishEvent('vehicle', 'brake:$brake', 'on');
    await _publishButtonEvent('brake:$brake:on');

    await Future.delayed(const Duration(milliseconds: 100));

    // Release
    await _publishEvent('vehicle', 'brake:$brake', 'off');
    await _publishButtonEvent('brake:$brake:off');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCard(int index) {
    switch (index) {
      case 0:
        return _buildSection(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Motor Current (A)'),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _simulatedMotorCurrent.toDouble(),
                        min: -10,
                        max: 100,
                        divisions: 110,
                        label: _simulatedMotorCurrent.toString(),
                        onChanged: (value) {
                          setState(() => _simulatedMotorCurrent = value.toInt());
                          _updateEngineValues();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        _simulatedMotorCurrent.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      case 1:
        return _buildSection(
          'Battery 0',
          [
            Row(
              children: [
                const Text('Present'),
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
            _buildSegmentedButton(
              'State',
              ['unknown', 'asleep', 'active', 'idle'],
              _battery0State,
              (value) {
                setState(() => _battery0State = value);
                _publishEvent('battery:0', 'state', value);
              },
            ),
          ],
        );
      case 2:
        return _buildSection(
          'Battery 1',
          [
            Row(
              children: [
                const Text('Present'),
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
            _buildSegmentedButton(
              'State',
              ['unknown', 'asleep', 'active', 'idle'],
              _battery1State,
              (value) {
                setState(() => _battery1State = value);
                _publishEvent('battery:1', 'state', value);
              },
            ),
          ],
        );
      case 3:
        return _buildSection(
          'Blinker State',
          [
            _buildSegmentedButton(
              '',
              ['off', 'left', 'right', 'both'],
              _blinkerState,
              (value) {
                setState(() => _blinkerState = value);
                _publishEvent('vehicle', 'blinker:state', value);
              },
            ),
          ],
        );
      case 4:
        return _buildSection(
          'Handlebar',
          [
            _buildSegmentedButton(
              '',
              ['unlocked', 'locked'],
              _handlebarPosition,
              (value) {
                setState(() => _handlebarPosition = value);
                _publishEvent('vehicle', 'handlebar:position', value);
              },
            ),
          ],
        );
      case 5:
        return _buildSection(
          'Kickstand',
          [
            _buildSegmentedButton(
              '',
              ['up', 'down'],
              _kickstandState,
              (value) {
                setState(() => _kickstandState = value);
                _publishEvent('vehicle', 'kickstand', value);
              },
            ),
          ],
        );
      case 6:
        return _buildSection(
          'Vehicle State',
          [
            _buildSegmentedButton(
              '',
              ['parked', 'ready-to-drive', 'stand-by', 'booting', 'shutting-down'],
              _vehicleState,
              (value) {
                setState(() => _vehicleState = value);
                _publishEvent('vehicle', 'state', value);
              },
            ),
            if (_vehicleStateExpanded)
              _buildSegmentedButton(
                '',
                ['hibernating', 'hibernating-imminent', 'suspending', 'suspending-imminent', 'off', 'updating'],
                _vehicleState,
                (value) {
                  setState(() => _vehicleState = value);
                  _publishEvent('vehicle', 'state', value);
                },
              ),
            TextButton(
              onPressed: () {
                setState(() => _vehicleStateExpanded = !_vehicleStateExpanded);
              },
              child: Text(_vehicleStateExpanded ? 'Show Less' : 'Show More'),
            ),
          ],
        );
      case 7:
        return _buildSection(
          'Left Brake',
          [
            _buildSegmentedButton(
              '',
              ['off', 'on'],
              _leftBrakeState,
              (value) {
                // Only update state when UI button is pressed
                setState(() => _leftBrakeState = value);
                if (value == 'on') {
                  print('SIM: Left brake pressed via UI button');
                } else {
                  print('SIM: Left brake released via UI button');
                }
                _publishEvent('vehicle', 'brake:left', value);
                _publishButtonEvent('brake:left:$value');
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeTap('left'),
                  child: const Text('Tap'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeDoubleTap('left'),
                  child: const Text('Double-Tap'),
                ),
              ],
            ),
          ],
        );
      case 8:
        return _buildSection(
          'Right Brake',
          [
            _buildSegmentedButton(
              '',
              ['off', 'on'],
              _rightBrakeState,
              (value) {
                // Only update state when UI button is pressed
                setState(() => _rightBrakeState = value);
                if (value == 'on') {
                  print('SIM: Right brake pressed via UI button');
                } else {
                  print('SIM: Right brake released via UI button');
                }
                _publishEvent('vehicle', 'brake:right', value);
                _publishButtonEvent('brake:right:$value');
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeTap('right'),
                  child: const Text('Tap'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeDoubleTap('right'),
                  child: const Text('Double-Tap'),
                ),
              ],
            ),
          ],
        );
      case 9:
        return _buildSection(
          'Seatbox Button',
          [
            // Button with mouse events
            Listener(
              onPointerDown: (_) => _seatboxButtonDown(),
              onPointerUp: (_) => _seatboxButtonUp(),
              onPointerCancel: (_) => _seatboxButtonUp(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                  backgroundColor: _seatboxButtonState == 'on' ? Colors.green.shade700 : Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // This is needed for the button to be clickable,
                  // but the actual events are handled by the Listener
                },
                child: Text(
                  'Seatbox button',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Current state indicator
            Row(
              children: [
                const Text('Current state:'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _seatboxButtonState == 'on' ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _seatboxButtonState.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case 10:
        return _buildSection(
          'Bluetooth',
          [
            _buildSegmentedButton(
              '',
              ['disconnected', 'connected'],
              _bluetoothStatus,
              (value) {
                setState(() => _bluetoothStatus = value);
                _publishEvent('ble', 'status', value);
              },
            ),
          ],
        );
      case 11:
        return _buildSection(
          'Internet Status',
          [
            _buildSegmentedButton(
              '',
              ['disconnected', 'connected'],
              _internetStatus,
              (value) {
                setState(() => _internetStatus = value);
                _publishEvent('internet', 'status', value);
              },
            ),
            _buildSlider(
              'Signal Quality',
              _signalQuality,
              0,
              100,
              (value) {
                setState(() => _signalQuality = value.toInt());
                _publishEvent('internet', 'signal-quality', value.toInt().toString());
              },
            ),
          ],
        );
      case 12:
        return _buildSection(
          'Cloud Status',
          [
            _buildSegmentedButton(
              '',
              ['disconnected', 'connected'],
              _cloudStatus,
              (value) {
                setState(() => _cloudStatus = value);
                _publishEvent('internet', 'unu-cloud', value);
              },
            ),
          ],
        );
      case 13:
        return _buildSection(
          'GPS Status',
          [
            _buildSegmentedButton(
              '',
              ['off', 'searching', 'fix-established', 'error'],
              _gpsState,
              (value) {
                setState(() => _gpsState = value);
                _publishEvent('gps', 'state', value);
              },
            ),
          ],
        );
      case 14:
        return _buildSection(
          'OTA Status',
          [
            Text('General OTA Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSegmentedButton(
              '',
              ['none', 'initializing', 'checking-updates', 'device-updated', 'waiting-dashboard'],
              _otaStatus,
              (value) {
                setState(() => _otaStatus = value);
                _publishEvent('ota', 'status', value);
              },
            ),
            if (_otaStatusExpanded) ...[
              _buildSegmentedButton(
                '',
                ['downloading-updates', 'installing-updates', 'checking-update-error', 'downloading-update-error'],
                _otaStatus,
                (value) {
                  setState(() => _otaStatus = value);
                  _publishEvent('ota', 'status', value);
                },
              ),
              _buildSegmentedButton(
                '',
                [
                  'installing-update-error',
                  'installation-complete-waiting-dashboard-reboot',
                  'installation-complete-waiting-reboot',
                  'unknown'
                ],
                _otaStatus,
                (value) {
                  setState(() => _otaStatus = value);
                  _publishEvent('ota', 'status', value);
                },
              ),
            ],
            TextButton(
              onPressed: () {
                setState(() => _otaStatusExpanded = !_otaStatusExpanded);
              },
              child: Text(_otaStatusExpanded ? 'Show Less' : 'Show More'),
            ),
            SizedBox(height: 16),
            Text('DBC Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSegmentedButton(
              '',
              ['', 'downloading', 'installing'],
              _dbcStatus,
              (value) {
                setState(() => _dbcStatus = value);
                _publishEvent('ota', 'status:dbc', value);
              },
            ),
            SizedBox(height: 8),
            Text('MDB Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSegmentedButton(
              '',
              ['', 'downloading', 'installing'],
              _mdbStatus,
              (value) {
                setState(() => _mdbStatus = value);
                _publishEvent('ota', 'status:mdb', value);
              },
            ),
            SizedBox(height: 8),
            Text('Update Type:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSegmentedButton(
              '',
              ['none', 'blocking', 'non-blocking'],
              _updateType,
              (value) {
                setState(() => _updateType = value);
                _publishEvent('ota', 'update-type', value);
              },
            ),
          ],
        );
      case 15:
        return _buildSection(
          'Odometer',
          [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Odometer (km)'),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  controller: TextEditingController(text: _simulatedOdometer.toStringAsFixed(1)),
                  onSubmitted: (value) {
                    final parsedValue = double.tryParse(value);
                    if (parsedValue != null) {
                      setState(() => _simulatedOdometer = parsedValue);
                      _updateEngineValues();
                    }
                  },
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard cluster
                SizedBox(
                  width: 480,
                  height: 560,
                  child: _buildSection("Screen", [MainScreen()]),
                ),

                const SizedBox(width: 16),

                // Control cards in a wrap layout next to the dashboard
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: [
                      for (int i = 0; i < 16; i++)
                        SizedBox(
                          width: 220,
                          child: _buildCard(i),
                        ),
                    ],
                  ),
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

  Widget _buildSegmentedButton(
    String label,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) Text(label),
        if (label.isNotEmpty) const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : null,
                foregroundColor: isSelected ? Theme.of(context).colorScheme.onPrimary : null,
              ),
              onPressed: () => onSelected(option),
              child: Text(option, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
