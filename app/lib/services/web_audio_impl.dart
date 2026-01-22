// Web implementation using dart:html
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

html.AudioElement? _bgmElement;

void playWebAudio(String path, double volume, double playbackRate) {
  try {
    // Create new audio element each time for overlapping sounds
    final audio = html.AudioElement(path);
    audio.volume = volume;
    audio.playbackRate = playbackRate;
    audio.play();
  } catch (e) {
    // Ignore errors
  }
}

void playWebBGM(String path, double volume) {
  try {
    stopWebBGM();
    _bgmElement = html.AudioElement(path);
    _bgmElement!.volume = volume;
    _bgmElement!.loop = true;
    _bgmElement!.play();
  } catch (e) {
    // Ignore errors
  }
}

void stopWebBGM() {
  _bgmElement?.pause();
  _bgmElement = null;
}

void pauseWebBGM() {
  _bgmElement?.pause();
}

void resumeWebBGM() {
  _bgmElement?.play();
}

void setWebBGMVolume(double volume) {
  if (_bgmElement != null) {
    _bgmElement!.volume = volume;
  }
}
