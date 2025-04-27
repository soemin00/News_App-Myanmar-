/*import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = '32727cf985e64ea9a7c6b264d594150c'; // Hardcoded API key
  final String baseUrl = 'https://newsapi.org/v2';

  Future<Map<String, dynamic>> fetchNews({String query = 'Myanmar'}) async {
    // Construct the API URL
    final url = Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey');

    // Debugging: Print the URL being called
    print('Fetching news from: $url');

    try {
      // Make the HTTP GET request
      final response = await http.get(url);

      // Debugging: Print the status code and response body
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse and return the JSON response
        return json.decode(response.body);
      } else {
        // Handle API errors
        throw Exception(
          'Failed to load news. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle network errors (e.g., no internet connection)
      print('Error fetching news: $e');
      throw Exception('Failed to load news: $e');
    }
  }
}
*/

import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String _apiKey = '32727cf985e64ea9a7c6b264d594150c';
  final String _baseUrl = 'https://newsapi.org/v2';

  /// Fetch news articles from NewsAPI
  /// [query]: Search term (e.g., "Myanmar")
  /// [endpoint]: "everything" or "top-headlines"
  /// [sortBy]: "publishedAt", "popularity", etc.
  /// [pageSize]: Number of articles to return
  Future<Map<String, dynamic>> fetchNews({
    String query = 'Myanmar',
    String endpoint = 'everything',
    String sortBy = 'publishedAt',
    int pageSize = 20,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final url = Uri.parse(
      '$_baseUrl/$endpoint?q=$query&sortBy=$sortBy&pageSize=$pageSize'
      '&apiKey=$_apiKey&timestamp=$timestamp',
    );

    print('📰 Fetching news from: $url');

    try {
      final response = await http.get(url);

      print('✅ Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
          '❌ Failed to load news. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('⚠️ Error fetching news: $e');
      throw Exception('Failed to load news: $e');
    }
  }
}
