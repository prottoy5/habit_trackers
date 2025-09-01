import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggleToday;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCard({super.key, required this.habit, required this.onToggleToday, required this.onEdit, required this.onDelete});

  bool get completedToday {
    final now = DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    return habit.completionHistory.any((d)=>d.year==t.year && d.month==t.month && d.day==t.day);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(habit.category, style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                ),
                const Spacer(),
                Text('Streak: ${habit.currentStreak}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(habit.title, style: Theme.of(context).textTheme.titleMedium),
            if (habit.notes != null) Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(habit.notes!),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: onToggleToday,
                  child: Row(children: [
                    Icon(completedToday ? Icons.check_circle : Icons.radio_button_unchecked),
                    const SizedBox(width: 6),
                    const Text('Mark Today'),
                  ]),
                ),
                const Spacer(),
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
