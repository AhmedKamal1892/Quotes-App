class Quote {
  int id;
  String quote;
  String author;
  Quote({
    required this.id,
    required this.quote,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'quote': quote});
    result.addAll({'author': author});

    return result;
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id']?.toInt() ?? 0,
      quote: map['quote'] ?? '',
      author: map['author'] ?? '',
    );
  }
}
