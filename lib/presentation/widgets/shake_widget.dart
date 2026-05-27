import 'dart:math' as math;
import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double shakeCount;
  final double shakeOffset;

  const ShakeWidget({
    required Key key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.shakeCount = 3.0,
    this.shakeOffset = 8.0,
  }) : super(key: key);

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void shake() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        final progress = _animationController.value;
        if (progress == 0.0 || progress == 1.0) {
          return child!;
        }
        final offset = widget.shakeOffset * math.sin(progress * widget.shakeCount * 2 * math.pi);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
    );
  }
}
