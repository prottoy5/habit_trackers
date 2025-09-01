import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/quotes_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/quote_card.dart';

class QuotesTab extends StatefulWidget {
  const QuotesTab({super.key});

  @override
  State<QuotesTab> createState() => _QuotesTabState();
}

class _QuotesTabState extends State<QuotesTab> {
  @override
  void initState() {
    super.initState();
    // Load quotes when the widget first appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final qp = context.read<QuotesProvider>();
      final auth = context.read<AuthProvider>();

      // Initialize favorites watching if user is available
      if (auth.user != null) {
        qp.watchFavorites(auth.user!);
      }

      // Load quotes initially
      qp.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final qp = context.watch<QuotesProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.user;

    if (user == null) return const SizedBox.shrink();

    if (qp.loading) {
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5, // number of shimmer placeholders
        itemBuilder: (_, __) => const _QuoteShimmer(),
      );
    }

    if (qp.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(qp.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => qp.refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (qp.quotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No quotes available.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => qp.refresh(),
              child: const Text('Load Quotes'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => await qp.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: qp.quotes.length,
        itemBuilder: (_, i) {
          final q = qp.quotes[i];
          final isFavorited = qp.favorites.any((f) => f.id == q.id);

          return QuoteCard(
            quote: q,
            favorited: isFavorited,
            onCopy: () async {
              await Clipboard.setData(
                ClipboardData(text: '${q.text} — ${q.author}'),
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied')),
                );
              }
            },
            onFavorite: () {
              qp.toggleFavorite(user, q);
            },
          );
        },
      ),
    );
  }
}

// -------------------- Shimmer Placeholder --------------------
class _QuoteShimmer extends StatelessWidget {
  const _QuoteShimmer();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 16, width: double.infinity, color: Colors.white),
              const SizedBox(height: 6),
              Container(height: 14, width: 120, color: Colors.white),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(height: 20, width: 60, color: Colors.white),
                  const Spacer(),
                  Container(height: 20, width: 20, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}