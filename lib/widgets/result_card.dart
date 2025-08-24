import 'package:flutter/material.dart';
import '../models/lottery_result.dart';
import 'number_ball.dart';

class ResultCard extends StatelessWidget {
  final LotteryResult result;

  const ResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${result.loteria} — Concurso ${result.concurso}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              result.data,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.dezenas
                  .map((dezena) => NumberBall(
                        number: int.parse(dezena),
                        isLarge: false,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
