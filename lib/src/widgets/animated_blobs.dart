import 'package:flutter/material.dart';

class AnimatedBlobs extends StatelessWidget {
  const AnimatedBlobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pinkAccent.withOpacity(0.1),
      child: const Center(child: Text('Animated Blobs go here')),
    );
  }
}
