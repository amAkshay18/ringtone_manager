import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../services/ringtone_service.dart';
import '../services/secure_storage_service.dart';

class RingtoneController extends GetxController with WidgetsBindingObserver {
  final RingtoneService _ringtoneService = RingtoneService();
  final SecureStorageService _secureStorage = SecureStorageService();

  final ringtoneInfo = RxString('');
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final hasPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Register this controller as an observer for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
    checkPermissions();
    loadLastRingtone();
  }

  @override
  void onClose() {
    // Remove the observer when controller is closed
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app resumes from background, recheck permissions
    if (state == AppLifecycleState.resumed) {
      checkPermissions();
    }
  }

  // Check for permissions when the app starts or resumes
  Future<void> checkPermissions() async {
    if (Platform.isAndroid) {
      bool hasAudioPermission = false;
      bool hasStoragePermission = false;

      // Check for audio permission (Android 13+)
      if (await Permission.audio.isGranted) {
        hasAudioPermission = true;
      }

      // Check for storage permission (older Android)
      if (await Permission.storage.isGranted) {
        hasStoragePermission = true;
      }

      // Update permission state based on checks
      hasPermission.value = hasAudioPermission || hasStoragePermission;

      // Clear any previous error if permissions are now granted
      if (hasPermission.value && errorMessage.value.contains('permission')) {
        hasError.value = false;
        errorMessage.value = '';
      }
    } else {
      // iOS doesn't need explicit permissions for our use case
      hasPermission.value = true;
    }
  }

  // Request necessary permissions based on Android version
  Future<void> requestPermissions() async {
    if (!Platform.isAndroid) {
      hasPermission.value = true;
      return;
    }

    bool permissionGranted = false;

    // For Android 13+ (API level 33+)
    PermissionStatus audioStatus = await Permission.audio.status;
    if (audioStatus.isPermanentlyDenied) {
      _showSettingsDialog();
      return;
    } else if (audioStatus.isDenied) {
      final newStatus = await Permission.audio.request();
      if (newStatus.isGranted) {
        permissionGranted = true;
      }
    } else if (audioStatus.isGranted) {
      permissionGranted = true;
    }

    // For older Android versions, try storage permission if audio not available
    if (!permissionGranted) {
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus.isPermanentlyDenied) {
        _showSettingsDialog();
        return;
      } else if (storageStatus.isDenied) {
        final newStatus = await Permission.storage.request();
        if (newStatus.isGranted) {
          permissionGranted = true;
        }
      } else if (storageStatus.isGranted) {
        permissionGranted = true;
      }
    }

    hasPermission.value = permissionGranted;

    if (!permissionGranted) {
      hasError.value = true;
      errorMessage.value = 'Permission denied. Cannot access ringtones.';
    } else {
      hasError.value = false;
      errorMessage.value = '';
    }
  }

  // Show a dialog to direct user to app settings
  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Audio permission is required to access ringtones. Please enable it in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
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
    // First check if we already have permission
    await checkPermissions();

    // If we don't have permission, request it
    if (!hasPermission.value && Platform.isAndroid) {
      await requestPermissions();
      if (!hasPermission.value) return; // Stop if permission not granted
    }

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
    // First check if we already have permission
    await checkPermissions();

    // If we don't have permission, request it
    if (!hasPermission.value && Platform.isAndroid) {
      await requestPermissions();
      if (!hasPermission.value) return; // Stop if permission not granted
    }

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
