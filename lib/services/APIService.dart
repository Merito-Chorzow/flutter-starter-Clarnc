import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/entry.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String postsEndpoint = '$baseUrl/posts';

  Future<List<JournalEntry>> getEntries() async {
    try {
      final response = await http.get(Uri.parse(postsEndpoint));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Convert API posts to JournalEntries
        return data.take(5).map((post) => JournalEntry(
          id: post['id'].toString(),
          title: post['title'],
          description: post['body'],
          createdAt: DateTime.now().subtract(Duration(days: post['id'])),
        )).toList();
      } else {
        throw Exception('Failed to load entries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load entries: $e');
    }
  }

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    try {
      final response = await http.post(
        Uri.parse(postsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': entry.title,
          'body': entry.description,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        return JournalEntry(
          id: data['id'].toString(),
          title: data['title'],
          description: data['body'],
          latitude: entry.latitude,
          longitude: entry.longitude,
          imagePath: entry.imagePath,
          createdAt: entry.createdAt,
        );
      } else {
        throw Exception('Failed to create entry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create entry: $e');
    }
  }
}