import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ringtone_controller.dart';

class HomeView extends StatelessWidget {
  final RingtoneController controller = Get.put(RingtoneController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ringtone Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Obx(() {
            // Show permission request UI if permission is not granted
            if (!controller.hasPermission.value) {
              return _buildPermissionRequest();
            }

            // Show main UI if permission is granted
            return _buildMainContent();
          }),
        ),
      ),
    );
  }

  // Widget for requesting permissions
  Widget _buildPermissionRequest() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.music_note,
          size: 80,
          color: Colors.grey,
        ),
        SizedBox(height: 20),
        Text(
          'Storage Permission Required',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'This app needs permission to access your device storage to retrieve and play ringtones.',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.requestPermissions(),
          child: Text('Grant Permission'),
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
          onPressed: () => controller.fetchDefaultRingtone(),
          child: Text('Fetch Default Ringtone'),
        ),
        SizedBox(height: 20),

        // Ringtone info display section
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 100),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.hasError.value) {
              return Text(
                'Error: ${controller.errorMessage}',
                style: TextStyle(color: Colors.red),
              );
            }

            return controller.ringtoneInfo.isEmpty
                ? Text('No ringtone information available')
                : Text(controller.ringtoneInfo.value);
          }),
        ),

        SizedBox(height: 20),

        ElevatedButton(
          onPressed: () => controller.playRingtone(),
          child: Text('Play Ringtone'),
        ),
      ],
    );
  }
}
