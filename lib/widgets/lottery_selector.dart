import 'package:flutter/material.dart';
import '../models/lottery_type.dart';

class LotterySelector extends StatelessWidget {
  final LotteryType selectedType;
  final ValueChanged<LotteryType> onChanged;

  const LotterySelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: DropdownButton<LotteryType>(
        value: selectedType,
        onChanged: (value) => value != null ? onChanged(value) : null,
        underline: const SizedBox(),
        dropdownColor: Theme.of(context).colorScheme.surface,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        items: LotteryType.values.map((type) {
          return DropdownMenuItem<LotteryType>(
            value: type,
            child: Text(type.displayName),
          );
        }).toList(),
      ),
    );
  }
}
