import 'package:flutter/material.dart';
import 'src/widgets/player.dart';

void main() {
  runApp(LofiMusicApp());
}

class LofiMusicApp extends StatelessWidget {
  const LofiMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LofiMusic',
      home: PlayerScreen(),
    );
  }
}
