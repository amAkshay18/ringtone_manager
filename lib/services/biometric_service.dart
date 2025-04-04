import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if device supports biometrics
  Future<bool> isBiometricsAvailable() async {
    try {
      // Check if biometrics are available
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (canAuthenticate) {
        // Get available biometrics
        final availableBiometrics = await _localAuth.getAvailableBiometrics();
        // Check if fingerprint authentication is available
        return availableBiometrics.contains(BiometricType.fingerprint);
      }
      return false;
    } on PlatformException {
      return false;
    }
  }

  // Authenticate with fingerprint
  Future<bool> authenticateWithFingerprint() async {
    try {
      if (!await isBiometricsAvailable()) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to access ringtone information',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly:
              true, // Only allow biometrics, not PIN/pattern/password
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.notEnrolled ||
          e.code == auth_error.passcodeNotSet) {
        // Handle specific error cases if needed
        return false;
      }
      return false;
    }
  }
}
