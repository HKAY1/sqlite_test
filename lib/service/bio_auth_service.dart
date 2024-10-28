import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BioAuthService {
  BioAuthService._();

  static final BioAuthService instance = BioAuthService._();

  late LocalAuthentication auth;
  bool canCheckBiometrics = false;
  bool isSupported = false;

  void initialize() async {
    auth = LocalAuthentication();
    isSupported = await auth.isDeviceSupported();
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (_) {
      canCheckBiometrics = false;
    }
  }

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
