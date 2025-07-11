import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/deezer_api.dart';
import 'sidebar.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<Track> _tracks = [];
  int _selectedIndex = 0;
  bool _isPlaying = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final tracks = await DeezerApiService.fetchLofiTracks();
    setState(() {
      _tracks = tracks;
      _loading = false;
    });
  }

  void _onTrackSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _isPlaying = false;
    });
  }

  void _playPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextTrack() {
    setState(() {
      _selectedIndex = (_selectedIndex + 1) % _tracks.length;
      _isPlaying = false;
    });
  }

  void _prevTrack() {
    setState(() {
      _selectedIndex = (_selectedIndex - 1 + _tracks.length) % _tracks.length;
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LofiMusic')),
      drawer: Sidebar(
        selectedIndex: _selectedIndex,
        onTrackSelected: _onTrackSelected,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _tracks.isEmpty
              ? const Center(child: Text('No tracks found'))
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        _tracks[_selectedIndex].cover,
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _tracks[_selectedIndex].title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${_tracks[_selectedIndex].artist} 2 ${_tracks[_selectedIndex].album}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          iconSize: 36,
                          onPressed: _prevTrack,
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          iconSize: 48,
                          onPressed: _playPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          iconSize: 36,
                          onPressed: _nextTrack,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
