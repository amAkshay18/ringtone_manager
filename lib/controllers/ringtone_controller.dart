import 'package:get/get.dart';
import '../services/ringtone_service.dart';
import '../services/secure_storage_service.dart';
import 'dart:convert';

class RingtoneController extends GetxController {
  final RingtoneService _ringtoneService = RingtoneService();
  final SecureStorageService _secureStorage = SecureStorageService();

  final ringtoneInfo = RxString('');
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastRingtone();
  }

  // Load the last retrieved ringtone from secure storage
  Future<void> loadLastRingtone() async {
    String? lastRingtone = await _secureStorage.getLastRingtoneData();
    if (lastRingtone != null && lastRingtone.isNotEmpty) {
      ringtoneInfo.value = lastRingtone;
    }
  }

  // Get the default ringtone information
  Future<void> fetchDefaultRingtone() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final ringtoneData = await _ringtoneService.getDefaultRingtone();
      final String title = ringtoneData['title'] ?? 'Unknown';
      final String path = ringtoneData['path'] ?? 'Unknown';

      ringtoneInfo.value = 'Title: $title\nPath: $path';

      // Store in secure storage
      await _secureStorage.saveRingtoneData(ringtoneInfo.value);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      ringtoneInfo.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  // Play the default ringtone
  Future<void> playRingtone() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      await _ringtoneService.playDefaultRingtone();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
