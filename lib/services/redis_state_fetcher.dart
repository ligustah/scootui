import 'package:redis/redis.dart';
import '../models/vehicle_state.dart';

class RedisStateFetcher {
  final VehicleState vehicleState;
  final Command? Function() getCommand;

  RedisStateFetcher({
    required this.vehicleState,
    required this.getCommand,
  });

  Future<void> fetchInitialState() async {
    if (getCommand() == null) throw Exception('No active connection');
    
    try {
      await Future.wait([
        _fetchEngineState(),
        _fetchVehicleState(),
        _fetchCBBatteryState(),
        _fetchSystemState(),
        _fetchAuxBatteryState(),
        _fetchBattery0State(),
        _fetchBattery1State(),
        _fetchGpsState(),
      ]);
    } catch (e) {
      print('Error fetching state: $e');
      rethrow;
    }
  }

  Future<void> _fetchBattery0State() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "battery:0", "present"]),
        command.send_object(["HGET", "battery:0", "state"]),
        command.send_object(["HGET", "battery:0", "voltage"]),
        command.send_object(["HGET", "battery:0", "current"]),
        command.send_object(["HGET", "battery:0", "charge"]),
        command.send_object(["HGET", "battery:0", "temperature-state"]),
        command.send_object(["HGET", "battery:0", "cycle-count"]),
        command.send_object(["HGET", "battery:0", "state-of-health"]),
        command.send_object(["HGET", "battery:0", "serial-number"]),
        command.send_object(["HGET", "battery:0", "manufacturing-date"]),
        command.send_object(["HGET", "battery:0", "fw-version"]),
        command.send_object(["SMEMBERS", "battery:0:fault"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('battery:0', 'present', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('battery:0', 'state', responses[1]);
      if (responses[2] != null) vehicleState.updateFromRedis('battery:0', 'voltage', responses[2]);
      if (responses[3] != null) vehicleState.updateFromRedis('battery:0', 'current', responses[3]);
      if (responses[4] != null) vehicleState.updateFromRedis('battery:0', 'charge', responses[4]);
      if (responses[5] != null) vehicleState.updateFromRedis('battery:0', 'temperature-state', responses[5]);
      if (responses[6] != null) vehicleState.updateFromRedis('battery:0', 'cycle-count', responses[6]);
      if (responses[7] != null) vehicleState.updateFromRedis('battery:0', 'state-of-health', responses[7]);
      if (responses[8] != null) vehicleState.updateFromRedis('battery:0', 'serial-number', responses[8]);
      if (responses[9] != null) vehicleState.updateFromRedis('battery:0', 'manufacturing-date', responses[9]);
      if (responses[10] != null) vehicleState.updateFromRedis('battery:0', 'fw-version', responses[10]);
      if (responses[11] != null) vehicleState.updateFromRedis('battery:0', 'fault', responses[11]);
    } catch (e) {
      print('Error fetching battery 0 state: $e');
      rethrow;
    }
  }

  Future<void> _fetchBattery1State() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "battery:1", "present"]),
        command.send_object(["HGET", "battery:1", "state"]),
        command.send_object(["HGET", "battery:1", "voltage"]),
        command.send_object(["HGET", "battery:1", "current"]),
        command.send_object(["HGET", "battery:1", "charge"]),
        command.send_object(["HGET", "battery:1", "temperature-state"]),
        command.send_object(["HGET", "battery:1", "cycle-count"]),
        command.send_object(["HGET", "battery:1", "state-of-health"]),
        command.send_object(["HGET", "battery:1", "serial-number"]),
        command.send_object(["HGET", "battery:1", "manufacturing-date"]),
        command.send_object(["HGET", "battery:1", "fw-version"]),
        command.send_object(["SMEMBERS", "battery:1:fault"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('battery:1', 'present', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('battery:1', 'state', responses[1]);
      if (responses[2] != null) vehicleState.updateFromRedis('battery:1', 'voltage', responses[2]);
      if (responses[3] != null) vehicleState.updateFromRedis('battery:1', 'current', responses[3]);
      if (responses[4] != null) vehicleState.updateFromRedis('battery:1', 'charge', responses[4]);
      if (responses[5] != null) vehicleState.updateFromRedis('battery:1', 'temperature-state', responses[5]);
      if (responses[6] != null) vehicleState.updateFromRedis('battery:1', 'cycle-count', responses[6]);
      if (responses[7] != null) vehicleState.updateFromRedis('battery:1', 'state-of-health', responses[7]);
      if (responses[8] != null) vehicleState.updateFromRedis('battery:1', 'serial-number', responses[8]);
      if (responses[9] != null) vehicleState.updateFromRedis('battery:1', 'manufacturing-date', responses[9]);
      if (responses[10] != null) vehicleState.updateFromRedis('battery:1', 'fw-version', responses[10]);
      if (responses[11] != null) vehicleState.updateFromRedis('battery:1', 'fault', responses[11]);
    } catch (e) {
      print('Error fetching battery 1 state: $e');
      rethrow;
    }
  }

  Future<void> _fetchCBBatteryState() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "cb-battery", "cell-voltage"]),
        command.send_object(["HGET", "cb-battery", "current"]),
        command.send_object(["HGET", "cb-battery", "temperature"]),
        command.send_object(["HGET", "cb-battery", "remaining-capacity"]),
        command.send_object(["HGET", "cb-battery", "full-capacity"]),
        command.send_object(["HGET", "cb-battery", "time-to-full"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('cb-battery', 'cell-voltage', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('cb-battery', 'current', responses[1]);
      if (responses[2] != null) vehicleState.updateFromRedis('cb-battery', 'temperature', responses[2]);
      if (responses[3] != null) vehicleState.updateFromRedis('cb-battery', 'remaining-capacity', responses[3]);
      if (responses[4] != null) vehicleState.updateFromRedis('cb-battery', 'full-capacity', responses[4]);
      if (responses[5] != null) vehicleState.updateFromRedis('cb-battery', 'time-to-full', responses[5]);
    } catch (e) {
      print('Error fetching CB battery state: $e');
      rethrow;
    }
  }

  Future<void> _fetchEngineState() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "engine-ecu", "speed"]),
        command.send_object(["HGET", "engine-ecu", "rpm"]),
        command.send_object(["HGET", "engine-ecu", "odometer"]),
        command.send_object(["HGET", "engine-ecu", "throttle"]),
        command.send_object(["HGET", "engine-ecu", "motor:voltage"]),
        command.send_object(["HGET", "engine-ecu", "motor:current"]),
        command.send_object(["HGET", "engine-ecu", "brake:left"]),
        command.send_object(["HGET", "engine-ecu", "brake:right"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('engine-ecu', 'speed', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('engine-ecu', 'rpm', responses[1]);
      if (responses[2] != null) vehicleState.updateFromRedis('engine-ecu', 'odometer', responses[2]);
      if (responses[3] != null) vehicleState.updateFromRedis('engine-ecu', 'throttle', responses[3]);
      if (responses[4] != null) vehicleState.updateFromRedis('engine-ecu', 'motor:voltage', responses[4]);
      if (responses[5] != null) vehicleState.updateFromRedis('engine-ecu', 'motor:current', responses[5]);
      if (responses[6] != null) vehicleState.updateFromRedis('engine-ecu', 'brake:left', responses[6]);
      if (responses[7] != null) vehicleState.updateFromRedis('engine-ecu', 'brake:right', responses[7]);
    } catch (e) {
      print('Error fetching engine state: $e');
      rethrow;
    }
  }

  Future<void> _fetchVehicleState() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "vehicle", "blinker:state"]),
        command.send_object(["HGET", "vehicle", "handlebar:position"]),
        command.send_object(["HGET", "vehicle", "handlebar:lock-sensor"]),
        command.send_object(["HGET", "vehicle", "kickstand"]),
        command.send_object(["HGET", "vehicle", "seatbox:button"]),
        command.send_object(["HGET", "vehicle", "state"]),
        command.send_object(["HGET", "vehicle", "seatbox:lock"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('vehicle', 'blinker:state', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('vehicle', 'handlebar:position', responses[1]);
      if (responses[2] != null) vehicleState.updateFromRedis('vehicle', 'handlebar:lock-sensor', responses[2]);
      if (responses[3] != null) vehicleState.updateFromRedis('vehicle', 'kickstand', responses[3]);
      if (responses[4] != null) vehicleState.updateFromRedis('vehicle', 'seatbox:button', responses[4]);
      if (responses[5] != null) vehicleState.updateFromRedis('vehicle', 'state', responses[5]);
      if (responses[6] != null) vehicleState.updateFromRedis('vehicle', 'seatbox:lock', responses[6]);
    } catch (e) {
      print('Error fetching vehicle state: $e');
      rethrow;
    }
  }

  Future<void> _fetchSystemState() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "internet", "status"]),
        command.send_object(["HGET", "internet", "access-tech"]),
        command.send_object(["HGET", "internet", "signal-quality"]),
        command.send_object(["HGET", "system", "mdb-version"]),
        command.send_object(["HGET", "system", "nrf-fw-version"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('internet', 'status', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('internet', 'access-tech', responses[1]);
      if (responses[2] != null) vehicleState.updateFromRedis('internet', 'signal-quality', responses[2]);
      if (responses[3] != null) vehicleState.updateFromRedis('system', 'mdb-version', responses[3]);
      if (responses[4] != null) vehicleState.updateFromRedis('system', 'nrf-fw-version', responses[4]);
    } catch (e) {
      print('Error fetching system state: $e');
      rethrow;
    }
  }

  Future<void> _fetchAuxBatteryState() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "aux-battery", "voltage"]),
        command.send_object(["HGET", "aux-battery", "charge-status"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('aux-battery', 'voltage', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('aux-battery', 'charge-status', responses[1]);
    } catch (e) {
      print('Error fetching aux battery state: $e');
      rethrow;
    }
  }

  Future<void> _fetchGpsState() async {
    try {
      final command = getCommand();
      if (command == null) return;

      final futures = [
        command.send_object(["HGET", "gps", "latitude"]),
        command.send_object(["HGET", "gps", "longitude"]),
        command.send_object(["HGET", "gps", "altitude"]),
        command.send_object(["HGET", "gps", "speed"]),
        command.send_object(["HGET", "gps", "course"]),
        command.send_object(["HGET", "gps", "timestamp"]),
      ];
      
      final responses = await Future.wait(futures);
      
      if (responses[0] != null) vehicleState.updateFromRedis('gps', 'latitude', responses[0]);
      if (responses[1] != null) vehicleState.updateFromRedis('gps', 'longitude', responses[1]);
      if (responses[2] != null) vehicleState.updateFromRedis('gps', 'altitude', responses[2]);
      if (responses[3] != null) vehicleState.updateFromRedis('gps', 'speed', responses[3]);
      if (responses[4] != null) vehicleState.updateFromRedis('gps', 'course', responses[4]);
      if (responses[5] != null) vehicleState.updateFromRedis('gps', 'timestamp', responses[5]);
    } catch (e) {
      print('Error fetching GPS state: $e');
      rethrow;
    }
  }
}