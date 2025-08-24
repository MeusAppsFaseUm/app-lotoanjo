import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NumberBall extends StatelessWidget {
  final int number;
  final int index;
  final bool isLarge;

  const NumberBall({
    super.key,
    required this.number,
    this.index = 0,
    this.isLarge = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 70.0 : 50.0;
    final fontSize = isLarge ? 24.0 : 18.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
      .scale(
        begin: const Offset(0.5, 0.5),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
      )
      .fadeIn(
        duration: const Duration(milliseconds: 400),
      );
  }
}
