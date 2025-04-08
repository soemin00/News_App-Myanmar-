import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/news_model.dart';
import '../screens/news_detail_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: news.urlToImage,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              news.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(news.description),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Published: ${news.publishedAt}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(news: news),
                  ),
                );
              },
              child: const Text('Read More'),
            ),
          ),
        ],
      ),
    );
  }
}
