import 'package:shared_preferences/shared_preferences.dart';

/// First-launch flag. Stays on the device and is never uploaded.
class LaunchPrefs {
  LaunchPrefs._();

  static const seenOnboardingKey = 'hooplab_seen_onboarding_v1';
  static const supportEmail = 'support@hooplab.app';

  static bool ready = false;
  static bool seenOnboarding = false;

  static Future<void> ensureLoaded() async {
    if (ready) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      seenOnboarding = prefs.getBool(seenOnboardingKey) ?? false;
    } catch (_) {
      seenOnboarding = false;
    }
    ready = true;
  }

  static Future<void> markOnboardingSeen() async {
    seenOnboarding = true;
    ready = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(seenOnboardingKey, true);
    } catch (_) {}
  }
}
