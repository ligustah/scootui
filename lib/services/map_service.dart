import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MapService {
  static Future<bool> isMapAvailable() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final mapPath = '${appDir.path}/maps/map.mbtiles';
      return await File(mapPath).exists();
    } catch (e) {
      print('Error checking map availability: $e');
      return false;
    }
  }
} 