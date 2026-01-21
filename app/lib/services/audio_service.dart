import 'package:audioplayers/audioplayers.dart';

/// Service for playing game sounds
class AudioService {
  static AudioService? _instance;
  static AudioService get instance {
    _instance ??= AudioService._();
    return _instance!;
  }

  AudioService._();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  bool _sfxEnabled = true;
  bool _bgmEnabled = true;
  double _sfxVolume = 1.0;
  double _bgmVolume = 0.5;

  // Getters
  bool get sfxEnabled => _sfxEnabled;
  bool get bgmEnabled => _bgmEnabled;
  double get sfxVolume => _sfxVolume;
  double get bgmVolume => _bgmVolume;

  /// Initialize audio service
  Future<void> init() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// Play drop sound effect
  Future<void> playDrop() async {
    if (!_sfxEnabled) return;
    await _playSound('drop.mp3');
  }

  /// Play merge sound effect
  Future<void> playMerge() async {
    if (!_sfxEnabled) return;
    await _playSound('merge.mp3');
  }

  /// Play combo sound effect
  Future<void> playCombo(int comboCount) async {
    if (!_sfxEnabled) return;
    // Higher combo = higher pitch
    await _playSound('combo.mp3');
  }

  /// Play high value block created sound
  Future<void> playHighValue() async {
    if (!_sfxEnabled) return;
    await _playSound('high_value.mp3');
  }

  /// Play game over sound
  Future<void> playGameOver() async {
    if (!_sfxEnabled) return;
    await _playSound('game_over.mp3');
  }

  /// Play button click sound
  Future<void> playClick() async {
    if (!_sfxEnabled) return;
    await _playSound('click.mp3');
  }

  /// Play coin sound
  Future<void> playCoin() async {
    if (!_sfxEnabled) return;
    await _playSound('coin.mp3');
  }

  /// Play background music
  Future<void> playBGM() async {
    if (!_bgmEnabled) return;
    try {
      await _bgmPlayer.setVolume(_bgmVolume);
      await _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
    } catch (e) {
      // Audio file might not exist yet
    }
  }

  /// Stop background music
  Future<void> stopBGM() async {
    await _bgmPlayer.stop();
  }

  /// Pause background music
  Future<void> pauseBGM() async {
    await _bgmPlayer.pause();
  }

  /// Resume background music
  Future<void> resumeBGM() async {
    if (_bgmEnabled) {
      await _bgmPlayer.resume();
    }
  }

  /// Toggle sound effects
  void toggleSFX() {
    _sfxEnabled = !_sfxEnabled;
  }

  /// Toggle background music
  void toggleBGM() {
    _bgmEnabled = !_bgmEnabled;
    if (!_bgmEnabled) {
      stopBGM();
    } else {
      playBGM();
    }
  }

  /// Set SFX enabled state
  void setSFXEnabled(bool enabled) {
    _sfxEnabled = enabled;
  }

  /// Set BGM enabled state
  void setBGMEnabled(bool enabled) {
    _bgmEnabled = enabled;
    if (!_bgmEnabled) {
      stopBGM();
    }
  }

  /// Set SFX volume
  void setSFXVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
  }

  /// Set BGM volume
  void setBGMVolume(double volume) {
    _bgmVolume = volume.clamp(0.0, 1.0);
    _bgmPlayer.setVolume(_bgmVolume);
  }

  Future<void> _playSound(String filename) async {
    try {
      await _sfxPlayer.setVolume(_sfxVolume);
      await _sfxPlayer.play(AssetSource('audio/$filename'));
    } catch (e) {
      // Audio file might not exist yet
    }
  }

  /// Dispose resources
  void dispose() {
    _sfxPlayer.dispose();
    _bgmPlayer.dispose();
  }
}
