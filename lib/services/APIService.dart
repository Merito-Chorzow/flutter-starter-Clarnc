import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/entry.dart';

class ApiService {

  static const String baseUrl = 'https://690614f9ee3d0d14c134c10e.mockapi.io';
  static const String entriesEndpoint = '$baseUrl/api/v1/journal_entries/';

  Future<List<JournalEntry>> getEntries() async {
    try {
      print('Fetching entries from: $entriesEndpoint');
      final response = await http.get(Uri.parse(entriesEndpoint));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Successfully fetched ${data.length} entries from API');
        
        return data.map((item) => JournalEntry.fromJson(item)).toList();
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load entries: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Failed to load entries: $e');
    }
  }

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    try {
      print('Creating entry at: $entriesEndpoint');
      print('Entry data: ${entry.toJson()}');
      
      final response = await http.post(
        Uri.parse(entriesEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(entry.toJson()),
      );

      if (response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        print('Successfully created entry with ID: ${data['id']}');
        return JournalEntry.fromJson(data);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to create entry: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Failed to create entry: $e');
    }
  }


  Future<void> deleteEntry(String entryId) async {
    try {
      print('Deleting entry: $entryId');
      final response = await http.delete(
        Uri.parse('$entriesEndpoint/$entryId'),
      );

      if (response.statusCode == 200) {
        print('Successfully deleted entry: $entryId');
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to delete entry: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Failed to delete entry: $e');
    }
  }
}