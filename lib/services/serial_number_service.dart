import 'dart:io';

class SerialNumberService {
  /// Reads the device serial number from the system files
  /// Returns the serial number as a 64-bit integer if successful, null otherwise.
  static Future<int?> readSerialNumber() async {
    int serialNumber = 0;

    final List<String> fileNames = ['/sys/fsl_otp/HW_OCOTP_CFG0', '/sys/fsl_otp/HW_OCOTP_CFG1'];

    try {
      for (final fileName in fileNames) {
        final file = File(fileName);
        if (!await file.exists()) {
          return null;
        }

        final content = await file.readAsString();
        final trimmedContent = content.trim();

        // Parse the hex string to an integer, handling the 0x prefix if present
        String hexValue = trimmedContent;
        if (hexValue.startsWith('0x')) {
          hexValue = hexValue.substring(2);
        }
        final int? value = int.tryParse(hexValue, radix: 16);
        if (value == null) {
          return null;
        }

        serialNumber += value;
      }

      if (serialNumber != 0) {
        return serialNumber;
      }
    } catch (e) {
      print('Error reading serial number: $e');
    }

    return null;
  }
}
