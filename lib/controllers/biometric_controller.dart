import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class BiometricController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    authenticate(); // Call biometric auth on app start
  }

  Future<void> authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        isAuthenticated.value = false;
        return;
      }

      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      isAuthenticated.value = didAuthenticate;
    } catch (e) {
      print('Biometric auth error: $e');
      isAuthenticated.value = false;
    }
  }
}
