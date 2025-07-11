import 'package:just_audio/just_audio.dart';
import '../models/track.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;
  List<Track> _tracks = [];
  int _currentIndex = 0;

  void setTracks(List<Track> tracks) {
    _tracks = tracks;
  }

  Future<void> playTrack(int index) async {
    if (_tracks.isEmpty) return;
    _currentIndex = index;
    await _player.setUrl(_tracks[index].preview);
    await _player.play();
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> next() async {
    if (_tracks.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _tracks.length;
    await playTrack(_currentIndex);
  }

  Future<void> previous() async {
    if (_tracks.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _tracks.length) % _tracks.length;
    await playTrack(_currentIndex);
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  void dispose() {
    _player.dispose();
  }
}
