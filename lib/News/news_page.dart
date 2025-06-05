import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';
import 'news_model.dart';
import 'package:intl/intl.dart'; // For formatting date

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<NewsArticle>> _newsFuture;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _newsFuture = NewsService().fetchNews(filter: _selectedFilter);
  }

  void _onFilterChanged(String? filter) {
    setState(() {
      _selectedFilter = filter!;
      _newsFuture = NewsService().fetchNews(filter: _selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Market News')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'nyse', child: Text('New York Stock Exchange')),
                DropdownMenuItem(value: 'lse', child: Text('London Stock Exchange')),
                DropdownMenuItem(value: 'nse', child: Text('National Stock Exchange')),
                DropdownMenuItem(value: 'bse', child: Text('Bombay Stock Exchange')),
              ],
              onChanged: _onFilterChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred while fetching data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No news available'));
                }

                // Sort articles by published date in descending order (latest first)
                final newsArticles = snapshot.data!..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

                return ListView.builder(
                  itemCount: newsArticles.length,
                  itemBuilder: (context, index) {
                    final article = newsArticles[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0), // Add some spacing between articles
                      elevation: 4, // Add elevation for a shadow effect
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the image at the top
                          if (article.imageUrl.isNotEmpty)
                            Image.network(
                              article.imageUrl,
                              width: double.infinity, // Make the image stretch to fill the card width
                              height: 200, // Set a fixed height for the image
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                );
                              },
                            ),
                          const SizedBox(height: 8), // Add some spacing after the image
                          // Display the title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Display additional details
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(article.description),
                                Text(
                                  'Source: ${article.source}',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  'Author: ${article.author}',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  'Published on: ${DateFormat.yMMMd().format(article.publishedAt)}',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // "Read more" link
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () => _launchURL(article.url),
                              child: const Text(
                                'Read more',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8), // Add some spacing at the bottom
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Disclaimer at the bottom of the page
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Disclaimer: The news displayed in this app is fetched from external sources. ZenithX is not responsible for the content or accuracy of the news.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'An error occurred while fetching data';
    }
  }
}

class NewsDetailPage extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(article.imageUrl),
            const SizedBox(height: 16),
            Text(article.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Source: ${article.source}', style: const TextStyle(fontStyle: FontStyle.italic)),
            Text('Author: ${article.author}', style: const TextStyle(fontStyle: FontStyle.italic)),
            Text('Published on: ${DateFormat.yMMMd().format(article.publishedAt)}'),
            const SizedBox(height: 16),
            Text(article.description),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _launchURL(article.url),
              child: const Text(
                'Read more',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'An error occurred while fetching data';
    }
  }
}
