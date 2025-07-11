import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/track.dart';

class Sidebar extends StatelessWidget {
  final List<Track> tracks;
  final int selectedIndex;
  final ValueChanged<int> onTrackSelected;
  const Sidebar({
    super.key,
    required this.tracks,
    required this.selectedIndex,
    required this.onTrackSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              border: Border(
                right: BorderSide(
                  color: Colors.white.withOpacity(0.25),
                  width: 2,
                ),
              ),
            ),
            child:
                tracks.isEmpty
                    ? const Center(child: Text('No tracks found'))
                    : ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        return ListTile(
                          selected: index == selectedIndex,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              track.cover,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.music_note,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          title: Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            track.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            onTrackSelected(index);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
