class News {
  final String status;
  final int totalResults;
  final List<dynamic> articles;

  News({
    required this.status,
    required this.totalResults,
    required this.articles
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: json['articles']
    );
  }
}
