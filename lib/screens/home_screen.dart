import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../providers/auth_provider.dart' as my_auth;
import '../providers/habits_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/quotes_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/habit_card.dart';
import '../screens/habit_form_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/favorites_screen.dart';
import '../tabs/quotes_tab.dart'; // <- new QuotesTab

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  bool _initialized = false;

  // Firebase Analytics instance
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final auth = context.read<my_auth.AuthProvider>();
      final user = auth.user;
      if (user != null) {
        // Watch providers
        context.read<ProfileProvider>().watchProfile(user);
        context.read<HabitsProvider>().watch(user);
        context.read<QuotesProvider>().watchFavorites(user);
        context.read<QuotesProvider>().refresh();

        // Firestore test write
        _writeTestData(user.uid);

        // Log app_open event
        analytics.logEvent(
          name: 'app_open',
          parameters: {
            'userId': user.uid,
            'time': DateTime.now().toIso8601String(),
          },
        );
      }
      _initialized = true;
    }
  }

  // Firestore test write
  Future<void> _writeTestData(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('test').add({
        'userId': uid,
        'timestamp': DateTime.now(),
        'message': 'Hello Firebase!',
      });
      debugPrint('✅ Test data written successfully!');
    } catch (e) {
      debugPrint('❌ Error writing test data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<my_auth.AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tabs = [
      _HabitsTab(user: user, analytics: analytics),
      const ProgressScreen(),
      const QuotesTab(), // <- updated QuotesTab
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    final titles = ['Habits', 'Progress', 'Quotes', 'Favorites', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          IconButton(
            onPressed: () => theme.toggle(),
            icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
          ),
          IconButton(
            onPressed: () => context.read<QuotesProvider>().refresh(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => auth.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Habits'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.format_quote), label: 'Quotes'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HabitFormScreen()),
        ),
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}

// -------------------- HABITS TAB --------------------
class _HabitsTab extends StatelessWidget {
  final User user;
  final FirebaseAnalytics analytics;
  const _HabitsTab({required this.user, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final hp = context.watch<HabitsProvider>();
    final habits = hp.habits;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 300));
      },
      child: habits.isEmpty
          ? const Center(child: Text('No habits yet.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: habits.length,
        itemBuilder: (_, i) {
          final h = habits[i];
          return HabitCard(
            habit: h,
            onToggleToday: () {
              hp.toggleComplete(user, h, DateTime.now());

              // Analytics event
              analytics.logEvent(
                name: 'habit_toggled',
                parameters: {
                  'userId': user.uid,
                  'habitId': h.id,
                  'time': DateTime.now().toIso8601String(),
                },
              );
            },
            onEdit: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => HabitFormScreen(editHabit: h)),
            ),
            onDelete: () => hp.remove(user, h.id),
          );
        },
      ),
    );
  }
}
