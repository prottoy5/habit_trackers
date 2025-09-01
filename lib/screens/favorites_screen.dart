import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/quotes_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/quote_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final qp = context.watch<QuotesProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.user;

    if (user == null) return const SizedBox.shrink();

    if (qp.loading) {
      // Show shimmer placeholders while loading
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (_, __) => const _QuoteShimmer(),
      );
    }

    if (qp.favorites.isEmpty) {
      return const Center(child: Text('No favorite quotes yet.'));
    }

    return RefreshIndicator(
      onRefresh: () async => await qp.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: qp.favorites.length,
        itemBuilder: (_, i) {
          final q = qp.favorites[i];

          return QuoteCard(
            quote: q,
            favorited: true,
            onCopy: () async {
              await Clipboard.setData(
                ClipboardData(text: '${q.text} — ${q.author}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied')),
              );
            },
            onFavorite: () {
              qp.toggleFavorite(user, q); // Remove from favorites
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
