import 'package:flutter/material.dart';

class VisualizerWidget extends StatelessWidget {
  const VisualizerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.blueAccent.withOpacity(0.2),
      child: const Center(child: Text('Visualizer goes here')),
    );
  }
}
