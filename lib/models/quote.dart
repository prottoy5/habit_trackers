class Quote {
  final String id; // API or generated
  final String text;
  final String author;

  Quote({required this.id, required this.text, required this.author});

  Map<String, dynamic> toMap() => {'id': id, 'text': text, 'author': author};

  factory Quote.fromMap(Map<String, dynamic> map) => Quote(
    id: map['id'] ?? '',
    text: map['text'] ?? '',
    author: map['author'] ?? 'Unknown',
  );
}


