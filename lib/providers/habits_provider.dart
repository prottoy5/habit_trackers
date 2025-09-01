import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';
import '../services/firestore_service.dart';

class HabitsProvider extends ChangeNotifier {
  final _fs = FirestoreService();
  List<Habit> habits = [];
  Stream<List<Habit>>? _sub;

  void watch(User user) {
    _sub?.drain();
    _sub = _fs.watchHabits(user.uid);
    _sub!.listen((list) {
      habits = list;
      notifyListeners();
    });
  }

  Future<void> add(User user, Habit h) async => _fs.addHabit(user.uid, h);
  Future<void> update(User user, Habit h) async => _fs.updateHabit(user.uid, h);
  Future<void> remove(User user, String id) async => _fs.deleteHabit(user.uid, id);

  // Completion logic
  Future<void> toggleComplete(User user, Habit h, DateTime date) async {
    final day = DateTime(date.year, date.month, date.day);
    final exists = h.completionHistory.any((d) => d.year == day.year && d.month == day.month && d.day == day.day);
    if (exists) {
      h.completionHistory.removeWhere((d) => d.year == day.year && d.month == day.month && d.day == day.day);
    } else {
      // Only allow current valid day/week completion
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (h.frequency == HabitFrequency.daily) {
        if (day != today) return;
      } else {
        // weekly: allow if same ISO week
        bool sameWeek(DateTime a, DateTime b) {
          int dayOfWeek(DateTime d) => d.weekday;
          final mondayA = a.subtract(Duration(days: dayOfWeek(a)-1));
          final mondayB = b.subtract(Duration(days: dayOfWeek(b)-1));
          return mondayA.year == mondayB.year && mondayA.month == mondayB.month && mondayA.day == mondayB.day;
        }
        if (!sameWeek(day, today)) return;
      }
      h.completionHistory.add(day);
    }
    // recalc streak
    h.currentStreak = _calculateStreak(h);
    await update(user, h);
  }

  int _calculateStreak(Habit h) {
    final history = [...h.completionHistory]..sort((a,b)=>b.compareTo(a)); // desc
    int streak = 0;
    DateTime cursor = DateTime.now();
    DateTime normalize(DateTime d) => DateTime(d.year,d.month,d.day);
    cursor = normalize(cursor);

    bool doneOn(DateTime d) => history.any((x) => x.year==d.year && x.month==d.month && x.day==d.day);

    if (h.frequency == HabitFrequency.daily) {
      while (true) {
        if (doneOn(cursor)) {
          streak++;
          cursor = cursor.subtract(const Duration(days:1));
        } else {
          break;
        }
      }
    } else {
      // weekly streak: check week by week (Monday start)
      DateTime mondayOf(DateTime d) => d.subtract(Duration(days: d.weekday-1));
      bool doneInWeek(DateTime d) {
        final m = mondayOf(d);
        return history.any((x) {
          final mx = mondayOf(x);
          return mx.year==m.year && mx.month==m.month && mx.day==m.day;
        });
      }
      while (true) {
        if (doneInWeek(cursor)) {
          streak++;
          cursor = cursor.subtract(const Duration(days:7));
        } else {
          break;
        }
      }
    }
    return streak;
  }
}
