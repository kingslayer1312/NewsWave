import 'dart:convert';
import '../model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static const BASE_URL = 'https://newsapi.org/v2/top-headlines';
  final String API_KEY;

  NewsService(this.API_KEY);

  Future<News> getNews(String country) async {
    final response = await http.get(
        Uri.parse("$BASE_URL?country=$country&apiKey=$API_KEY"));

    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception("Failed to fetch news data");
    }
  }
}