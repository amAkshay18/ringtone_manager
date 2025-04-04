import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveRingtoneData(String data) async {
    await _storage.write(key: 'last_ringtone', value: data);
  }

  Future<String?> getLastRingtoneData() async {
    return await _storage.read(key: 'last_ringtone');
  }
}
