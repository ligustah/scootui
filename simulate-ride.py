#!/usr/bin/env python3

import math
import random
import subprocess
import time
import sys


def publish_redis_value(channel, payload):
    """Set a value in Redis using redis-cli"""
    subprocess.run(["redis-cli", "PUBLISH", channel, str(payload)], check=True)


def set_redis_value(hash_name, field, value):
    """Set a value in Redis using redis-cli"""
    subprocess.run(["redis-cli", "HSET", hash_name,
                   field, str(value)], check=True)


def get_redis_value(hash_name, field, default=None):
    """Get a value from Redis using redis-cli"""
    try:
        result = subprocess.run(
            ["redis-cli", "HGET", hash_name, field],
            capture_output=True,
            text=True,
            check=True
        )
        value = result.stdout.strip()
        return float(value) if value else default
    except (subprocess.SubprocessError, ValueError):
        return default


def main():
    # Check command line arguments
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <starting_latitude> <starting_longitude>")
        sys.exit(1)

    # Initialize variables
    lat = float(sys.argv[1])
    lon = float(sys.argv[2])
    course = random.randint(0, 359)  # Random initial course (0-359 degrees)
    # Maximum course change per second (degrees)
    max_course_change = 90
    max_speed = 57                   # Maximum speed in km/h
    max_speed_delta = 25             # Maximum speed change per second (km/h)
    earth_radius = 6371.0            # Earth radius in km

    # Engine variables
    current_speed = 0                # Current speed in km/h
    prev_speed = 0                   # Previous speed in km/h

    # Motor variables
    min_voltage = 48.0               # Minimum voltage (V)
    max_voltage = 57.0               # Maximum voltage (V)
    nominal_voltage = 53.0           # Nominal voltage when cruising (V)
    battery_state = 0.8              # Battery state of charge (0.0-1.0)

    # Get current odometer value from Redis or initialize to 0
    odometer = get_redis_value("engine-ecu", "odometer", 0)

    print(f"Starting simulation from latitude: {lat}, longitude: {lon}")
    print(f"Initial odometer reading: {odometer} meters")
    print("Press Ctrl+C to stop")

    try:
        # Main loop
        while True:
            # Store previous speed for calculating delta
            prev_speed = current_speed

            # Update course with random change (maximum of max_course_change degrees)
            course_change = random.randint(-max_course_change,
                                           max_course_change)
            course = (course + course_change) % 360

            # Calculate target speed based on course change (slower when turning more)
            # Speed reduction factor: 1 (no reduction) to 0.3 (maximum reduction)
            speed_factor = 1 - 0.7 * abs(course_change) / max_course_change
            target_speed = max_speed * speed_factor

            # Limit speed change to max_speed_delta per second
            if target_speed > prev_speed:
                # Accelerating
                current_speed = min(target_speed, prev_speed + max_speed_delta)
            else:
                # Decelerating
                current_speed = max(target_speed, prev_speed - max_speed_delta)

            # Calculate actual speed delta (change in speed)
            speed_delta = current_speed - prev_speed

            # Calculate engine power based on speed delta
            if speed_delta < 0:  # Slowing down
                # Map from [min_delta..0] to [-10..0]
                # Using max_speed_delta as the reference for mapping
                power = (speed_delta / max_speed_delta) * 10.0
                power = max(-10.0, min(0.0, power))
            else:  # Speeding up or maintaining speed
                # Map from [0..max_delta] to [0..70]
                # Using max_speed_delta as the reference for mapping
                power = (speed_delta / max_speed_delta) * 70.0
                power = max(0.0, min(70.0, power))

            # Calculate motor voltage based on power, speed, and battery state
            # Voltage drops under load (acceleration) and rises with regeneration (braking)
            # Also introduce small random fluctuations
            # Base voltage depends on battery state
            base_voltage = min_voltage + \
                (max_voltage - min_voltage) * battery_state

            # Voltage drops under load (positive power) and increases during regeneration (negative power)
            # We scale the effect based on max power (70)
            power_effect = -3.0 * (power / 70.0)  # Max 3V drop at full power

            # Speed effect: voltage sags slightly at higher speeds due to internal resistance
            speed_effect = -1.0 * (current_speed / max_speed) * 0.5

            # Random small fluctuations (+/- 0.2V)
            random_fluctuation = (random.random() - 0.5) * 0.4

            # Calculate final voltage with limits
            voltage = base_voltage + power_effect + speed_effect + random_fluctuation
            voltage = max(min_voltage, min(max_voltage, voltage))

            # Format voltage to 1 decimal place
            motor_voltage = round(voltage, 1) * 100

            # Calculate distance traveled in 1 second (km)
            distance_km = current_speed / 3600

            # Calculate distance in meters for odometer
            distance_meters = distance_km * 1000

            # Update odometer in steps of 100m
            # First accumulate the exact distance
            odometer += distance_meters
            # Then round to nearest 100m for display/storage
            rounded_odometer = round(odometer / 100) * 100

            # Convert to radians for position calculation
            lat_rad = math.radians(lat)
            lon_rad = math.radians(lon)
            course_rad = math.radians(course)
            angular_distance = distance_km / earth_radius

            # Calculate new position
            sin_lat1 = math.sin(lat_rad)
            cos_lat1 = math.cos(lat_rad)
            sin_d = math.sin(angular_distance)
            cos_d = math.cos(angular_distance)
            sin_course = math.sin(course_rad)
            cos_course = math.cos(course_rad)

            lat2_rad = math.asin(sin_lat1 * cos_d +
                                 cos_lat1 * sin_d * cos_course)
            lon2_rad = lon_rad + math.atan2(sin_course * sin_d * cos_lat1,
                                            cos_d - sin_lat1 * math.sin(lat2_rad))

            # Convert back to degrees
            lat = math.degrees(lat2_rad)
            lon = math.degrees(lon2_rad)

            # Normalize longitude to -180 to 180
            lon = ((lon + 180) % 360) - 180

            # Format to 6 decimal places for GPS
            lat_formatted = f"{lat:.6f}"
            lon_formatted = f"{lon:.6f}"

            # Set GPS values in Redis
            set_redis_value("gps", "latitude", lat_formatted)
            set_redis_value("gps", "longitude", lon_formatted)
            set_redis_value("gps", "course", course)

            # Set engine-ecu values in Redis
            engine_speed = int(round(current_speed))
            set_redis_value("engine-ecu", "speed", engine_speed)
            engine_power = round(power, 1)
            set_redis_value("engine-ecu", "motor:current", engine_power * 100)
            set_redis_value("engine-ecu", "motor:voltage", motor_voltage * 100)
            set_redis_value("engine-ecu", "odometer", int(rounded_odometer))

            # Calculate target speed for display
            target_speed_int = int(round(target_speed))

            print(
                f"GPS: lat={lat_formatted}, lon={lon_formatted}, course={course}°")
            print(
                f"Engine: speed={engine_speed}km/h (target: {target_speed_int}km/h), power={engine_power}, delta={speed_delta:.2f}km/h")
            print(
                f"Motor: voltage={motor_voltage}V, current={engine_power}A")
            print(
                f"Odometer: {int(rounded_odometer)}m (traveled {int(distance_meters)}m this tick)")

            # Wait for one second
            time.sleep(1)

    except KeyboardInterrupt:
        print("\nSimulation stopped")
        sys.exit(0)


if __name__ == "__main__":
    main()
