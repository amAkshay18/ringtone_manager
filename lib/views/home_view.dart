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
          child: Column(
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
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
          ),
        ),
      ),
    );
  }
}
