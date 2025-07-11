import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBlobs extends StatefulWidget {
  const AnimatedBlobs({super.key});

  @override
  State<AnimatedBlobs> createState() => _AnimatedBlobsState();
}

class _AnimatedBlobsState extends State<AnimatedBlobs>
    with TickerProviderStateMixin {
  late final List<_BlobAnimation> _blobs;

  @override
  void initState() {
    super.initState();
    _blobs = [
      _BlobAnimation(
        size: 320,
        color: const Color(0xFFEEB6D6).withOpacity(0.35),
        initialOffset: const Offset(-120, -60),
        dx: 40,
        dy: 30,
        duration: 9000,
        vsync: this,
      ),
      _BlobAnimation(
        size: 220,
        color: const Color(0xFFB6F0E6).withOpacity(0.35),
        initialOffset: const Offset(-100, 80),
        dx: 30,
        dy: -40,
        duration: 11000,
        vsync: this,
        right: true,
      ),
      _BlobAnimation(
        size: 200,
        color: const Color(0xFFB6C7F0).withOpacity(0.35),
        initialOffset: const Offset(-80, 60),
        dx: -30,
        dy: 30,
        duration: 10000,
        vsync: this,
      ),
      _BlobAnimation(
        size: 180,
        color: const Color(0xFFD6B6F0).withOpacity(0.35),
        initialOffset: const Offset(-60, 40),
        dx: -40,
        dy: -30,
        duration: 12000,
        vsync: this,
        right: true,
      ),
    ];
  }

  @override
  void dispose() {
    for (final blob in _blobs) {
      blob.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Central radial gradient glow
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.7,
                colors: [
                  Color(0xFFF8F6FB),
                  Color(0xFFEDE7F6),
                  Color(0xFFF8F6FB),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ),
        ..._blobs.map((blob) => blob.build(context)),
      ],
    );
  }
}

class _BlobAnimation {
  final double size;
  final Color color;
  final Offset initialOffset;
  final double dx;
  final double dy;
  final int duration;
  final bool right;
  late final AnimationController controller;
  late final Animation<double> anim;

  _BlobAnimation({
    required this.size,
    required this.color,
    required this.initialOffset,
    required this.dx,
    required this.dy,
    required this.duration,
    required TickerProvider vsync,
    this.right = false,
  }) {
    controller = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: duration),
    )..repeat(reverse: true);
    anim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final offset = Offset(
          initialOffset.dx + dx * anim.value,
          initialOffset.dy + dy * anim.value,
        );
        return Positioned(
          left: right ? null : offset.dx,
          right: right ? -offset.dx : null,
          top: offset.dy,
          child: _Blob(size: size, color: color),
        );
      },
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(width: size, height: size, color: color),
      ),
    );
  }
}
