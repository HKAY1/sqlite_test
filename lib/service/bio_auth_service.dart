import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BioAuthService {
  BioAuthService._();

  static final BioAuthService instance = BioAuthService._();

  late LocalAuthentication auth;
  late SharedPreferences prefs;
  bool canCheckBiometrics = false;
  bool isSupported = false;

  Future<void> initialize() async {
    auth = LocalAuthentication();
    prefs = await SharedPreferences.getInstance();
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

  Future<bool> createMPin(String pin) async {
    try {
      final res = await prefs.setString("mpin", pin);
      return res;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeMPin() async {
    try {
      final res = prefs.remove("mpin");
      return res;
    } catch (e) {
      return false;
    }
  }

  bool verifyPin(String pin) {
    try {
      final ogPin = prefs.getString("mpin") ?? "";
      return ogPin.contains(pin);
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePin(String pin) async {
    try {
      final ogPin = prefs.getString("mpin") ?? "";
      if (pin.contains(ogPin)) throw "Same Pin";
      final res = await prefs.setString("mpin", pin);
      return res;
    } catch (e) {
      return false;
    }
  }
}
