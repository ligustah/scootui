import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// Represents a saved location with coordinates and optional address
class SavedLocation extends Equatable {
  final int id;
  final double latitude;
  final double longitude;
  final String label;
  final DateTime createdAt;
  final DateTime lastUsedAt;

  const SavedLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.createdAt,
    required this.lastUsedAt,
  });

  /// Get coordinates as LatLng
  LatLng get coordinates => LatLng(latitude, longitude);

  /// Get coordinates as string for navigation
  String get coordinatesString => '$latitude,$longitude';

  /// Create a copy with updated fields
  SavedLocation copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? label,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) {
    return SavedLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  /// Create from Redis data
  factory SavedLocation.fromRedisData(int id, Map<String, String> data) {
    return SavedLocation(
      id: id,
      latitude: double.parse(data['latitude'] ?? '0.0'),
      longitude: double.parse(data['longitude'] ?? '0.0'),
      label: data['label'] ?? 'Unknown Location',
      createdAt: DateTime.parse(data['created-at'] ?? DateTime.now().toIso8601String()),
      lastUsedAt: DateTime.parse(data['last-used-at'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert to Redis data format
  Map<String, String> toRedisData() {
    return {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'label': label,
      'created-at': createdAt.toIso8601String(),
      'last-used-at': lastUsedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, latitude, longitude, label, createdAt, lastUsedAt];

  @override
  String toString() {
    return 'SavedLocation(id: $id, label: $label, lat: $latitude, lng: $longitude)';
  }
}
