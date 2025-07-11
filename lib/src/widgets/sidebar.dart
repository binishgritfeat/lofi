import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/deezer_api.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTrackSelected;
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onTrackSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<List<Track>>(
        future: DeezerApiService.fetchLofiTracks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final tracks = snapshot.data ?? [];
          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return ListTile(
                selected: index == selectedIndex,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(track.cover, width: 40, height: 40),
                ),
                title: Text(track.title),
                subtitle: Text(track.artist),
                onTap: () {
                  onTrackSelected(index);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
