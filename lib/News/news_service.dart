import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';

class NewsService {
  static const String _apiKey = '79f393bbf728404b89a9ae4a5f9b59b1';
  final Map<String, List<NewsArticle>> _cache = {};

  Future<List<NewsArticle>> fetchNews({String filter = 'all'}) async {
    if (_cache.containsKey(filter)) {
      return _cache[filter]!;
    }

    final String url;
    if (filter == 'all') {
      url = 'https://newsapi.org/v2/everything?q=stocks&apiKey=$_apiKey';
    } else {
      url = 'https://newsapi.org/v2/everything?q=stocks+$filter&apiKey=$_apiKey';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articles = data['articles'];

      // Filter out articles older than 2 months
      final newsArticles = articles.map((json) {
        NewsArticle article = NewsArticle.fromJson(json);
        if (article.publishedAt.isAfter(DateTime.now().subtract(const Duration(days: 60)))) {
          return article;
        }
      }).where((article) => article != null).cast<NewsArticle>().toList();

      _cache[filter] = newsArticles;
      return newsArticles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
