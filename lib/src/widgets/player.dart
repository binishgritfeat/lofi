import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/deezer_api.dart';
import '../services/audio_service.dart';
import 'sidebar.dart';
import 'animated_blobs.dart';
import 'dart:ui';
import 'glass_overlay.dart';

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
  bool _showAlbumArt = true;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _loadTracks();
    _audioService.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _loadTracks() async {
    final tracks = await DeezerApiService.fetchLofiTracks();
    _audioService.setTracks(tracks);
    setState(() {
      _tracks = tracks;
      _loading = false;
    });
    if (tracks.isNotEmpty) {
      await _audioService.playTrack(_selectedIndex);
    }
  }

  Future<void> _onTrackSelected(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    await _audioService.playTrack(index);
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
  }

  Future<void> _nextTrack() async {
    await _audioService.next();
    setState(() {
      _selectedIndex = (_selectedIndex + 1) % _tracks.length;
    });
  }

  Future<void> _prevTrack() async {
    await _audioService.previous();
    setState(() {
      _selectedIndex = (_selectedIndex - 1 + _tracks.length) % _tracks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.18),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'LofiMusic',
                style: TextStyle(color: Colors.black),
              ),
              leading: Builder(
                builder:
                    (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Sidebar(
        tracks: _tracks,
        selectedIndex: _selectedIndex,
        onTrackSelected: _onTrackSelected,
      ),
      body: Stack(
        children: [
          const AnimatedBlobs(),
          const GlassOverlay(),
          Center(
            child:
                _loading
                    ? const CircularProgressIndicator()
                    : _tracks.isEmpty
                    ? const Text('No tracks found')
                    : GlassPlayerCard(
                      track: _tracks[_selectedIndex],
                      isPlaying: _isPlaying,
                      showAlbumArt: _showAlbumArt,
                      onToggleArt:
                          () => setState(() => _showAlbumArt = !_showAlbumArt),
                      onPlayPause: _playPause,
                      onNext: _nextTrack,
                      onPrev: _prevTrack,
                    ),
          ),
        ],
      ),
    );
  }
}

class GlassPlayerCard extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final bool showAlbumArt;
  final VoidCallback onToggleArt;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const GlassPlayerCard({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.showAlbumArt,
    required this.onToggleArt,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService();
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.7),
                Colors.purple.withOpacity(0.08),
                Colors.blue.withOpacity(0.08),
                Colors.pink.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 36,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(
                      Icons.album,
                      color: Colors.black87,
                      size: 20,
                    ),
                    label: Text(
                      showAlbumArt ? 'Album Art' : 'Visualizer',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    onPressed: onToggleArt,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child:
                    showAlbumArt
                        ? Image.network(
                          track.cover,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 180,
                                height: 180,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.music_note,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 180,
                              height: 180,
                              color: Colors.grey[100],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        )
                        : Container(
                          width: 180,
                          height: 80,
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              'Visualizer',
                              style: TextStyle(color: Colors.black26),
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 24),
              Text(
                track.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '${track.artist} • ${track.album}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Progress bar (functional)
              StreamBuilder<Duration>(
                stream: audioService.positionStream,
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration?>(
                    stream: audioService.durationStream,
                    builder: (context, durationSnapshot) {
                      final duration =
                          durationSnapshot.data ??
                          Duration(seconds: track.duration);
                      final max = duration.inMilliseconds.toDouble();
                      final value =
                          position.inMilliseconds.clamp(0, max).toDouble();
                      return Column(
                        children: [
                          Slider(
                            value: value,
                            min: 0,
                            max: max > 0 ? max : 1,
                            onChanged: (newValue) {
                              audioService.player.seek(
                                Duration(milliseconds: newValue.toInt()),
                              );
                            },
                            activeColor: Colors.greenAccent,
                            inactiveColor: Colors.purple.withOpacity(0.2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(
                                  Duration(milliseconds: value.toInt()),
                                ),
                                style: const TextStyle(color: Colors.black45),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GlassButton(icon: Icons.skip_previous, onTap: onPrev),
                  const SizedBox(width: 24),
                  _GlassButton(
                    icon: isPlaying ? Icons.pause : Icons.play_arrow,
                    onTap: onPlayPause,
                    size: 56,
                  ),
                  const SizedBox(width: 24),
                  _GlassButton(icon: Icons.skip_next, onTap: onNext),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  const _GlassButton({required this.icon, required this.onTap, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: size * 0.55),
      ),
    );
  }
}
