import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quote.dart';
import '../services/quotes_service.dart';
import '../services/firestore_service.dart';

class QuotesProvider extends ChangeNotifier {
  final _qs = QuotesService();
  final _fs = FirestoreService();

  List<Quote> quotes = [];
  bool loading = false;
  String? error;

  List<Quote> favorites = [];
  Stream<List<Quote>>? _favSub;

  /// Watch favorites in real-time for the current user
  void watchFavorites(User user) {
    _favSub?.drain();
    _favSub = _fs.watchFavoriteQuotes(user.uid);
    _favSub!.listen((list) {
      favorites = list;
      notifyListeners();
    });
  }

  /// Fetch quotes from API
  Future<void> refresh() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      quotes = await _qs.fetchQuotes(limit: 12);
    } catch (e) {
      error = 'Failed to fetch quotes. Please check your connection.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite status of a quote
  Future<void> toggleFavorite(User user, Quote quote) async {
    final isFavorited = favorites.any((q) => q.id == quote.id);
    if (isFavorited) {
      await _fs.unfavoriteQuote(user.uid, quote.id);
    } else {
      await _fs.favoriteQuote(user.uid, quote);
    }
  }
}