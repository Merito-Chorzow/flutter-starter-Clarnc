import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/entry.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String postsEndpoint = '$baseUrl/posts';

  // Local storage simulation since JSONPlaceholder doesn't actually save data
  static List<JournalEntry> _localEntries = [];

  Future<List<JournalEntry>> getEntries() async {
    try {
      final response = await http.get(Uri.parse(postsEndpoint));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Convert API posts to JournalEntries (take only 5 for demo)
        List<JournalEntry> apiEntries = data.take(5).map((post) => JournalEntry(
          id: post['id'].toString(),
          title: post['title'],
          description: post['body'],
          createdAt: DateTime.now().subtract(Duration(days: post['id'])),
        )).toList();

        // Combine API entries with locally created entries
        apiEntries.addAll(_localEntries);
        return apiEntries;
      } else {
        // Return local entries if API fails
        return _localEntries;
      }
    } catch (e) {
      // Return local entries if there's an error
      return _localEntries;
    }
  }

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    try {
      // Add to local storage first
      _localEntries.add(entry);

      // Also try to send to API (but JSONPlaceholder won't actually save it)
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
        print('Entry created successfully in API');
      } else {
        print('API creation failed but entry saved locally');
      }

      return entry;
    } catch (e) {
      print('Error creating entry: $e');
      // Still return the entry since it's saved locally
      return entry;
    }
  }
}