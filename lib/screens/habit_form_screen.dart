import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../providers/auth_provider.dart';
import '../providers/habits_provider.dart';

class HabitFormScreen extends StatefulWidget {
  final Habit? editHabit;
  const HabitFormScreen({super.key, this.editHabit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleC = TextEditingController();
  final notesC = TextEditingController();
  String category = 'Health';
  HabitFrequency freq = HabitFrequency.daily;
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    final h = widget.editHabit;
    if (h != null) {
      titleC.text = h.title;
      notesC.text = h.notes ?? '';
      category = h.category;
      freq = h.frequency;
      startDate = h.startDate;
    }
  }

  @override
  void dispose() {
    titleC.dispose();
    notesC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final hp = context.watch<HabitsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.editHabit==null ? 'Create Habit' : 'Edit Habit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleC,
                decoration: const InputDecoration(labelText: 'Title *'),
                validator: (v)=> (v==null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: category,
                items: Habit.predefinedCategories.map((c)=>DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v)=>setState(()=>category=v??'Others'),
                decoration: const InputDecoration(labelText: 'Category *'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<HabitFrequency>(
                value: freq,
                items: const [
                  DropdownMenuItem(value: HabitFrequency.daily, child: Text('Daily')),
                  DropdownMenuItem(value: HabitFrequency.weekly, child: Text('Weekly')),
                ],
                onChanged: (v)=>setState(()=>freq=v??HabitFrequency.daily),
                decoration: const InputDecoration(labelText: 'Frequency *'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: notesC,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final now = DateTime.now();
                  if (widget.editHabit == null) {
                    final h = Habit(
                      id: const Uuid().v4(),
                      title: titleC.text.trim(),
                      category: category,
                      frequency: freq,
                      createdAt: now,
                      startDate: startDate,
                      notes: notesC.text.trim().isEmpty ? null : notesC.text.trim(),
                    );
                    await hp.add(auth.user!, h);
                  } else {
                    final h = widget.editHabit!;
                    h.title = titleC.text.trim();
                    h.category = category;
                    h.frequency = freq;
                    h.notes = notesC.text.trim().isEmpty ? null : notesC.text.trim();
                    await hp.update(auth.user!, h);
                  }
                  if (mounted) Navigator.of(context).pop();
                },
                child: Text(widget.editHabit==null ? 'Create' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
