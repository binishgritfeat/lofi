import 'package:flutter/material.dart';

class GlassOverlay extends StatelessWidget {
  const GlassOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.2),
      child: const Center(child: Text('Glass Overlay goes here')),
    );
  }
}
