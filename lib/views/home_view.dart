import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innovitegra/controllers/biometric_controller.dart';
import '../controllers/ringtone_controller.dart';

class HomeView extends StatelessWidget {
  final RingtoneController controller = Get.put(RingtoneController());
  final BiometricController biometricController =
      Get.put(BiometricController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!biometricController.isAuthenticated.value) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Please authenticate"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: biometricController.authenticate,
                  child: const Text("Try Again"),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Ringtone Manager'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Obx(() {
              if (!controller.hasPermission.value) {
                return _buildPermissionRequest();
              }
              return _buildMainContent();
            }),
          ),
        ),
      );
    });
  }

  // Widget for requesting permissions
  Widget _buildPermissionRequest() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.music_note, size: 80, color: Colors.grey),
        const SizedBox(height: 20),
        const Text(
          'Storage Permission Required',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'This app needs permission to access your device storage to retrieve and play ringtones.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.requestPermissions(),
          child: const Text('Grant Permission'),
        ),
      ],
    );
  }

  // Main content widget when permission is granted
  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => controller.authenticateAndLoadRingtone(),
          child: const Text('Fetch Default Ringtone'),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 100),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.hasError.value) {
              return Text(
                'Error: ${controller.errorMessage}',
                style: const TextStyle(color: Colors.red),
              );
            }

            return controller.ringtoneInfo.isEmpty
                ? const Text(
                    'Hey user!\nClick the above button',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                : Text(controller.ringtoneInfo.value);
          }),
        ),
        const SizedBox(height: 20),
        Obx(() => ElevatedButton(
              onPressed: controller.ringtoneInfo.isNotEmpty
                  ? () => controller.playRingtone()
                  : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
              ),
              child: const Text('Play Ringtone'),
            )),
      ],
    );
  }
}
