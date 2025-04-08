import 'dart:convert';
import 'package:http/http.dart' as http;

/*
class NewsService {
  final String apiKey = '32727cf985e64ea9a7c6b264d594150c'; // Hardcoded API key
  final String baseUrl = 'https://newsapi.org/v2';

  Future<Map<String, dynamic>> fetchNews({String category = 'general'}) async {
    // Construct the API URL
    final url = Uri.parse(
      '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey',
    );

//https://newsapi.org/v2/everything?q=Myanmar&apiKey=$apiKey';

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
