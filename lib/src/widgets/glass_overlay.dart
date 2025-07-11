import 'dart:ui';
import 'package:flutter/material.dart';

class GlassOverlay extends StatelessWidget {
  const GlassOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.white.withOpacity(0.07),
            // Optionally add a border or gradient for extra glass effect
          ),
        ),
      ),
    );
  }
}
