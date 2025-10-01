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

  // Battery fault codes (Sets to match production behavior)
  Set<int> _battery0Fault = {};
  Set<int> _battery1Fault = {};

  // CB Battery values
  int _cbBatteryCharge = 100;
  bool _cbBatteryPresent = true;
  String _cbBatteryChargeStatus = 'not-charging';

  // AUX Battery values
  int _auxBatteryCharge = 100; // Valid values: 0, 25, 50, 75, 100
  int _auxBatteryVoltage = 12500; // 12.5V in mV
  String _auxBatteryChargeStatus = 'not-charging';

  // Expanded sections
  bool _vehicleStateExpanded = false;
  bool _otaStatusExpanded = false;

  // GPS timestamp simulation
  Timer? _gpsTimestampTimer;

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
      final blinkerState =
          await widget.repository.get('vehicle', 'blinker:state');
      final handlebarPosition =
          await widget.repository.get('vehicle', 'handlebar:position');
      final kickstandState =
          await widget.repository.get('vehicle', 'kickstand');
      final vehicleState = await widget.repository.get('vehicle', 'state');
      final leftBrakeState =
          await widget.repository.get('vehicle', 'brake:left');
      final rightBrakeState =
          await widget.repository.get('vehicle', 'brake:right');

      // Load system states
      final bluetoothStatus = await widget.repository.get('ble', 'status');
      final internetStatus = await widget.repository.get('internet', 'status');
      final signalQuality =
          await widget.repository.get('internet', 'signal-quality');
      final cloudStatus = await widget.repository.get('internet', 'unu-cloud');
      final gpsState = await widget.repository.get('gps', 'state');
      final otaStatus = await widget.repository.get('ota', 'status');
      final dbcStatus = await widget.repository.get('ota', 'status:dbc');
      final mdbStatus = await widget.repository.get('ota', 'status:mdb');
      final updateType = await widget.repository.get('ota', 'update-type');

      // Load battery states
      final battery0Present =
          await widget.repository.get('battery:0', 'present');
      final battery0Charge = await widget.repository.get('battery:0', 'charge');
      final battery0State = await widget.repository.get('battery:0', 'state');

      final battery1Present =
          await widget.repository.get('battery:1', 'present');
      final battery1Charge = await widget.repository.get('battery:1', 'charge');
      final battery1State = await widget.repository.get('battery:1', 'state');

      // Load battery fault codes from Sets
      final battery0FaultMembers =
          await widget.repository.getSetMembers('battery:0:fault');
      final battery1FaultMembers =
          await widget.repository.getSetMembers('battery:1:fault');

      // Load CB battery values
      final cbBatteryPresent =
          await widget.repository.get('cb-battery', 'present');
      final cbBatteryCharge =
          await widget.repository.get('cb-battery', 'charge');
      final cbBatteryChargeStatus =
          await widget.repository.get('cb-battery', 'charge-status');

      // Load AUX battery values
      final auxBatteryCharge =
          await widget.repository.get('aux-battery', 'charge');
      final auxBatteryVoltage =
          await widget.repository.get('aux-battery', 'voltage');
      final auxBatteryChargeStatus =
          await widget.repository.get('aux-battery', 'charge-status');

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
        if (signalQuality != null)
          _signalQuality = int.tryParse(signalQuality) ?? 0;
        if (cloudStatus != null) _cloudStatus = cloudStatus;
        if (gpsState != null) _gpsState = gpsState;
        if (otaStatus != null) _otaStatus = otaStatus;
        if (dbcStatus != null) _dbcStatus = dbcStatus;
        if (mdbStatus != null) _mdbStatus = mdbStatus;
        if (updateType != null) _updateType = updateType;

        if (battery0Present != null)
          _battery0Present = battery0Present.toLowerCase() == 'true';
        if (battery0Charge != null)
          _simulatedBatteryCharge0 = int.tryParse(battery0Charge) ?? 100;
        if (battery0State != null) _battery0State = battery0State;

        if (battery1Present != null)
          _battery1Present = battery1Present.toLowerCase() == 'true';
        if (battery1Charge != null)
          _simulatedBatteryCharge1 = int.tryParse(battery1Charge) ?? 100;
        if (battery1State != null) _battery1State = battery1State;

        // Battery fault codes
        _battery0Fault = battery0FaultMembers
            .map((m) => int.tryParse(m) ?? 0)
            .where((f) => f != 0)
            .toSet();
        _battery1Fault = battery1FaultMembers
            .map((m) => int.tryParse(m) ?? 0)
            .where((f) => f != 0)
            .toSet();

        // CB battery values
        if (cbBatteryPresent != null)
          _cbBatteryPresent = cbBatteryPresent.toLowerCase() == 'true';
        if (cbBatteryCharge != null)
          _cbBatteryCharge = int.tryParse(cbBatteryCharge) ?? 100;
        if (cbBatteryChargeStatus != null)
          _cbBatteryChargeStatus = cbBatteryChargeStatus;

        // AUX battery values
        if (auxBatteryCharge != null) {
          final charge = int.tryParse(auxBatteryCharge) ?? 100;
          // Round to nearest 25% increment
          _auxBatteryCharge = ((charge / 25).round() * 25).clamp(0, 100);
        }
        if (auxBatteryVoltage != null)
          _auxBatteryVoltage = int.tryParse(auxBatteryVoltage) ?? 12500;
        if (auxBatteryChargeStatus != null)
          _auxBatteryChargeStatus = auxBatteryChargeStatus;

        if (speed != null) _simulatedSpeed = int.tryParse(speed) ?? 0;
        if (rpm != null) _simulatedRpm = int.tryParse(rpm) ?? 0;
        if (odometer != null) {
          final odometerValue = double.tryParse(odometer) ?? 0.0;
          _simulatedOdometer =
              odometerValue / 1000.0; // Convert from meters to km
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

    // Initialize CB and AUX battery values
    await _updateCbBatteryValues();
    await _updateAuxBatteryValues();

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

    // Start GPS timestamp simulation if GPS is already fix-established
    if (_gpsState == 'fix-established') {
      _startGpsTimestampSimulation();
    }
  }

  Future<void> _updateEngineValues() async {
    final futures = [
      _publishEvent('engine-ecu', 'speed', _simulatedSpeed.toString()),
      _publishEvent('engine-ecu', 'rpm', _simulatedRpm.toString()),
      _publishEvent('engine-ecu', 'motor:current',
          (_simulatedMotorCurrent * 1000).toString()),
      _publishEvent(
          'engine-ecu', 'odometer', (_simulatedOdometer * 1000).toString()),
    ];
    await Future.wait(futures);
  }

  Future<void> _updateBatteryValues() async {
    final futures = [
      _publishEvent('battery:0', 'present', _battery0Present.toString()),
      _publishEvent('battery:1', 'present', _battery1Present.toString()),
      if (_battery0Present)
        _publishEvent(
            'battery:0', 'charge', _simulatedBatteryCharge0.toString()),
      if (_battery1Present)
        _publishEvent(
            'battery:1', 'charge', _simulatedBatteryCharge1.toString()),
    ];
    await Future.wait(futures);

    // Update fault Sets
    await _updateBatteryFaults(0, _battery0Fault);
    await _updateBatteryFaults(1, _battery1Fault);
  }

  Future<void> _updateBatteryFaults(int batteryId, Set<int> faults) async {
    final setKey = 'battery:$batteryId:fault';
    final currentMembers = await widget.repository.getSetMembers(setKey);
    final currentFaults = currentMembers
        .map((m) => int.tryParse(m) ?? 0)
        .where((f) => f != 0)
        .toSet();

    // Add new faults
    for (final fault in faults) {
      if (!currentFaults.contains(fault)) {
        await widget.repository.addToSet(setKey, fault.toString());
      }
    }

    // Remove faults that are no longer present
    for (final fault in currentFaults) {
      if (!faults.contains(fault)) {
        await widget.repository.removeFromSet(setKey, fault.toString());
      }
    }

    // Publish to trigger PUBSUB update
    if (faults != currentFaults) {
      // For InMemoryRepository, we need to trigger the PUBSUB notification
      if (widget.repository is InMemoryMDBRepository) {
        await _publishEvent('battery:$batteryId', 'fault', '');
      }
    }
  }

  Future<void> _updateCbBatteryValues() async {
    final futures = [
      _publishEvent('cb-battery', 'present', _cbBatteryPresent.toString()),
      _publishEvent('cb-battery', 'charge', _cbBatteryCharge.toString()),
      _publishEvent('cb-battery', 'charge-status', _cbBatteryChargeStatus),
    ];
    await Future.wait(futures);
  }

  Future<void> _updateAuxBatteryValues() async {
    final futures = [
      _publishEvent('aux-battery', 'charge', _auxBatteryCharge.toString()),
      _publishEvent('aux-battery', 'voltage', _auxBatteryVoltage.toString()),
      _publishEvent('aux-battery', 'charge-status', _auxBatteryChargeStatus),
    ];
    await Future.wait(futures);
  }

  Future<void> _publishEvent(String channel, String key, String value) async {
    await widget.repository.set(channel, key, value);
  }

  void _startGpsTimestampSimulation() {
    _gpsTimestampTimer?.cancel();
    _gpsTimestampTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_gpsState == 'fix-established') {
        final currentTimestamp = DateTime.now().toIso8601String();
        await _publishEvent('gps', 'timestamp', currentTimestamp);
      }
    });
  }

  void _stopGpsTimestampSimulation() {
    _gpsTimestampTimer?.cancel();
    _gpsTimestampTimer = null;
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
    _gpsTimestampTimer?.cancel();
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
                          setState(
                              () => _simulatedMotorCurrent = value.toInt());
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
            const SizedBox(height: 8),
            Text(
                'Fault Codes (Current: ${_battery0Fault.isEmpty ? "None" : _battery0Fault.map((f) => "B$f").join(", ")})',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _buildFaultButton(0, 'Clear', 0),
                _buildFaultButton(0, 'B7', 7),
                _buildFaultButton(0, 'B13', 13),
                _buildFaultButton(0, 'B14', 14),
                _buildFaultButton(0, 'B32', 32),
                _buildFaultButton(0, 'B34', 34),
              ],
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
            const SizedBox(height: 8),
            Text(
                'Fault Codes (Current: ${_battery1Fault.isEmpty ? "None" : _battery1Fault.map((f) => "B$f").join(", ")})',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _buildFaultButton(1, 'Clear', 0),
                _buildFaultButton(1, 'B7', 7),
                _buildFaultButton(1, 'B13', 13),
                _buildFaultButton(1, 'B14', 14),
                _buildFaultButton(1, 'B32', 32),
                _buildFaultButton(1, 'B34', 34),
              ],
            ),
          ],
        );
      case 3:
        return _buildSection(
          'CB Battery',
          [
            Row(
              children: [
                const Text('Present'),
                const SizedBox(width: 8),
                Checkbox(
                  value: _cbBatteryPresent,
                  onChanged: (value) {
                    setState(() => _cbBatteryPresent = value ?? false);
                    _updateCbBatteryValues();
                  },
                ),
              ],
            ),
            if (_cbBatteryPresent)
              _buildSlider(
                'Charge (%)',
                _cbBatteryCharge,
                0,
                100,
                (value) {
                  setState(() => _cbBatteryCharge = value.toInt());
                  _updateCbBatteryValues();
                },
              ),
            _buildSegmentedButton(
              'Charge Status',
              ['not-charging', 'charging', 'unknown'],
              _cbBatteryChargeStatus,
              (value) {
                setState(() => _cbBatteryChargeStatus = value);
                _updateCbBatteryValues();
              },
            ),
          ],
        );
      case 4:
        return _buildSection(
          'AUX Battery',
          [
            _buildSegmentedButton(
              'Charge (%)',
              ['0', '25', '50', '75', '100'],
              _auxBatteryCharge.toString(),
              (value) {
                setState(() => _auxBatteryCharge = int.parse(value));
                _updateAuxBatteryValues();
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Voltage (V)'),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _auxBatteryVoltage.toDouble(),
                        min: 9000, // 9V - to test critical voltage warning
                        max: 15000, // 15V
                        divisions: 50,
                        label:
                            '${(_auxBatteryVoltage / 1000.0).toStringAsFixed(1)}V',
                        onChanged: (value) {
                          setState(() => _auxBatteryVoltage = value.toInt());
                          _updateAuxBatteryValues();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        '${(_auxBatteryVoltage / 1000.0).toStringAsFixed(1)}V',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildSegmentedButton(
              'Charge Status',
              [
                'not-charging',
                'float-charge',
                'absorption-charge',
                'bulk-charge'
              ],
              _auxBatteryChargeStatus,
              (value) {
                setState(() => _auxBatteryChargeStatus = value);
                _updateAuxBatteryValues();
              },
            ),
          ],
        );
      case 5:
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
      case 6:
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
      case 7:
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
      case 8:
        return _buildSection(
          'Vehicle State',
          [
            _buildSegmentedButton(
              '',
              [
                'parked',
                'ready-to-drive',
                'stand-by',
                'booting',
                'shutting-down'
              ],
              _vehicleState,
              (value) {
                setState(() => _vehicleState = value);
                _publishEvent('vehicle', 'state', value);
              },
            ),
            if (_vehicleStateExpanded)
              _buildSegmentedButton(
                '',
                [
                  'hibernating',
                  'hibernating-imminent',
                  'suspending',
                  'suspending-imminent',
                  'off'
                ],
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
      case 9:
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeTap('left'),
                  child: const Text('Tap'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeDoubleTap('left'),
                  child: const Text('Double-Tap'),
                ),
              ],
            ),
          ],
        );
      case 10:
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeTap('right'),
                  child: const Text('Tap'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _simulateBrakeDoubleTap('right'),
                  child: const Text('Double-Tap'),
                ),
              ],
            ),
          ],
        );
      case 11:
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
                  backgroundColor: _seatboxButtonState == 'on'
                      ? Colors.green.shade700
                      : Colors.blue.shade700,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _seatboxButtonState == 'on'
                        ? Colors.green
                        : Colors.grey,
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
      case 12:
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
      case 13:
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
                _publishEvent(
                    'internet', 'signal-quality', value.toInt().toString());
              },
            ),
          ],
        );
      case 14:
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
      case 15:
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

                // Handle GPS timestamp simulation based on status
                if (value == 'fix-established') {
                  _startGpsTimestampSimulation();
                } else {
                  _stopGpsTimestampSimulation();
                }
              },
            ),
          ],
        );
      case 16:
        return _buildSection(
          'OTA Status',
          [
            Text('General OTA Status:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSegmentedButton(
              '',
              [
                'none',
                'initializing',
                'checking-updates',
                'device-updated',
                'waiting-dashboard'
              ],
              _otaStatus,
              (value) {
                setState(() => _otaStatus = value);
                _publishEvent('ota', 'status', value);
              },
            ),
            if (_otaStatusExpanded) ...[
              _buildSegmentedButton(
                '',
                [
                  'downloading-updates',
                  'installing-updates',
                  'checking-update-error',
                  'downloading-update-error'
                ],
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
      case 17:
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  controller: TextEditingController(
                      text: _simulatedOdometer.toStringAsFixed(1)),
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
                      for (int i = 0; i < 18; i++)
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                backgroundColor:
                    isSelected ? Theme.of(context).colorScheme.primary : null,
                foregroundColor:
                    isSelected ? Theme.of(context).colorScheme.onPrimary : null,
              ),
              onPressed: () => onSelected(option),
              child: Text(option, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFaultButton(int batteryId, String label, int faultCode) {
    final currentFaultSet = batteryId == 0 ? _battery0Fault : _battery1Fault;
    final isSelected = faultCode == 0
        ? currentFaultSet.isEmpty
        : currentFaultSet.contains(faultCode);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: isSelected
            ? (faultCode == 0 ? Colors.green : Colors.red.shade700)
            : null,
        foregroundColor: isSelected ? Colors.white : null,
      ),
      onPressed: () async {
        setState(() {
          if (faultCode == 0) {
            // Clear all faults
            if (batteryId == 0) {
              _battery0Fault.clear();
            } else {
              _battery1Fault.clear();
            }
          } else {
            // Toggle individual fault
            if (batteryId == 0) {
              if (_battery0Fault.contains(faultCode)) {
                _battery0Fault.remove(faultCode);
              } else {
                _battery0Fault.add(faultCode);
              }
            } else {
              if (_battery1Fault.contains(faultCode)) {
                _battery1Fault.remove(faultCode);
              } else {
                _battery1Fault.add(faultCode);
              }
            }
          }
        });
        await _updateBatteryValues();
      },
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}
