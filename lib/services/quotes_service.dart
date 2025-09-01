import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuotesService {
  /// Fetch quotes with CORS-friendly APIs for web
  Future<List<Quote>> fetchQuotes({int limit = 10}) async {
    // Try Quotable API first (CORS-friendly)
    try {
      return await _fetchFromQuotable(limit);
    } catch (e) {
      print('Quotable failed: $e');
      // Fallback to local quotes
      return _getLocalQuotes(limit);
    }
  }

  /// Fetch from Quotable API (CORS-friendly)
  Future<List<Quote>> _fetchFromQuotable(int limit) async {
    final uri = Uri.parse('https://api.quotable.io/quotes?limit=$limit');
    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('Quotable API returned ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    if (data['results'] is! List) {
      throw Exception('Invalid response format from Quotable');
    }

    final List<Quote> quotes = [];
    final results = data['results'] as List;
    for (var item in results) {
      final quoteText = item['content'] ?? '';
      final author = item['author'] ?? 'Unknown';

      if (quoteText.isNotEmpty) {
        quotes.add(Quote(
          id: item['id'] ?? '${quoteText}$author',
          text: quoteText,
          author: author,
        ));
      }
    }
    return quotes;
  }

  /// Local fallback quotes when APIs are unavailable
  List<Quote> _getLocalQuotes(int limit) {
    final localQuotes = [
      Quote(id: '1', text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs'),
      Quote(id: '2', text: 'Life is what happens to you while you\'re busy making other plans.', author: 'John Lennon'),
      Quote(id: '3', text: 'The future belongs to those who believe in the beauty of their dreams.', author: 'Eleanor Roosevelt'),
      Quote(id: '4', text: 'In the middle of difficulty lies opportunity.', author: 'Albert Einstein'),
      Quote(id: '5', text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.', author: 'Winston Churchill'),
      Quote(id: '6', text: 'The only impossible journey is the one you never begin.', author: 'Tony Robbins'),
      Quote(id: '7', text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt'),
      Quote(id: '8', text: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb'),
      Quote(id: '9', text: 'Your limitation—it\'s only your imagination.', author: 'Unknown'),
      Quote(id: '10', text: 'Push yourself, because no one else is going to do it for you.', author: 'Unknown'),
      Quote(id: '11', text: 'Great things never come from comfort zones.', author: 'Unknown'),
      Quote(id: '12', text: 'Dream it. Wish it. Do it.', author: 'Unknown'),
      Quote(id: '13', text: 'The way to get started is to quit talking and begin doing.', author: 'Walt Disney'),
      Quote(id: '14', text: 'Innovation distinguishes between a leader and a follower.', author: 'Steve Jobs'),
      Quote(id: '15', text: 'Don\'t let yesterday take up too much of today.', author: 'Will Rogers'),
    ];

    return localQuotes.take(limit).toList();
  }
}