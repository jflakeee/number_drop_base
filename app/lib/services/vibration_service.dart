import 'package:vibration/vibration.dart';

/// Service for haptic feedback
class VibrationService {
  static VibrationService? _instance;
  static VibrationService get instance {
    _instance ??= VibrationService._();
    return _instance!;
  }

  VibrationService._();

  bool _enabled = true;
  bool _hasVibrator = false;

  // Getters
  bool get enabled => _enabled;
  bool get hasVibrator => _hasVibrator;

  /// Initialize vibration service
  Future<void> init() async {
    _hasVibrator = await Vibration.hasVibrator() ?? false;
  }

  /// Light vibration for drop
  Future<void> vibrateLight() async {
    if (!_enabled || !_hasVibrator) return;
    await Vibration.vibrate(duration: 20);
  }

  /// Medium vibration for merge
  Future<void> vibrateMedium() async {
    if (!_enabled || !_hasVibrator) return;
    await Vibration.vibrate(duration: 50);
  }

  /// Strong vibration for combo
  Future<void> vibrateStrong() async {
    if (!_enabled || !_hasVibrator) return;
    await Vibration.vibrate(duration: 100);
  }

  /// Pattern vibration for high value block
  Future<void> vibratePattern() async {
    if (!_enabled || !_hasVibrator) return;
    await Vibration.vibrate(
      pattern: [0, 50, 50, 50, 50, 100],
      intensities: [0, 128, 0, 255, 0, 255],
    );
  }

  /// Heavy vibration for game over
  Future<void> vibrateGameOver() async {
    if (!_enabled || !_hasVibrator) return;
    await Vibration.vibrate(
      pattern: [0, 100, 100, 200],
      intensities: [0, 200, 0, 255],
    );
  }

  /// Toggle vibration
  void toggle() {
    _enabled = !_enabled;
  }

  /// Set enabled state
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }
}
