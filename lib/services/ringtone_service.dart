import 'package:flutter/services.dart';

class RingtoneService {
  static const platform =
      MethodChannel('com.example.ringtone_manager/ringtone');

  // Fetch default ringtone info from native code
  Future<Map<String, dynamic>> getDefaultRingtone() async {
    try {
      final result = await platform.invokeMethod('getDefaultRingtone');
      final Map<String, dynamic> ringtoneData =
          Map<String, dynamic>.from(result);
      return ringtoneData;
    } on PlatformException catch (e) {
      throw "Failed to get ringtone: ${e.message}";
    }
  }

  // Play the default ringtone
  Future<void> playDefaultRingtone() async {
    try {
      await platform.invokeMethod('playDefaultRingtone');
    } on PlatformException catch (e) {
      throw "Failed to play ringtone: ${e.message}";
    }
  }
}
