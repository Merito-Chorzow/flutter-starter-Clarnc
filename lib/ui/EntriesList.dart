import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/entry.dart';
import 'package:flutter_application_1/services/APIservice.dart';
import 'package:flutter_application_1/ui/EntriesDetails.dart';

class EntriesListPage extends StatefulWidget {
  const EntriesListPage({super.key});

  @override
  EntriesListPageState createState() => EntriesListPageState();
}

class EntriesListPageState extends State<EntriesListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<JournalEntry>> _entriesFuture;
  List<JournalEntry> _allEntries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void refreshEntries() {
    setState(() {
      _loadEntries();
    });
  }

  void _loadEntries() {
    setState(() {
      _entriesFuture = _apiService.getEntries().then((entries) {
        _allEntries = entries;
        return entries;
      });
    });
  }

  void _navigateToDetail(JournalEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryDetailPage(entry: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshEntries,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<JournalEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _buildEmptyState();
          } else if (snapshot.hasData) {
            return _buildEntriesList(snapshot.data!);
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load entries',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error.length > 100 ? 'Network error' : error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: refreshEntries,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note_add, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No entries yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Add your first entry using the + tab'),
        ],
      ),
    );
  }

  Widget _buildEntriesList(List<JournalEntry> entries) {
    // Sort entries by date (newest first)
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: _buildEntryLeading(entry),
            title: Text(
              entry.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.description.length > 50 
                    ? '${entry.description.substring(0, 50)}...' 
                    : entry.description,
                  maxLines: 1,
                ),
                Text(
                  '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year} ${entry.createdAt.hour}:${entry.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: entry.latitude != null 
                ? const Icon(Icons.location_on, color: Colors.green, size: 20)
                : null,
            onTap: () => _navigateToDetail(entry),
          ),
        );
      },
    );
  }

  Widget _buildEntryLeading(JournalEntry entry) {
    if (entry.imagePath != null && entry.imagePath!.isNotEmpty) {
      try {
        return CircleAvatar(
          backgroundImage: FileImage(File(entry.imagePath!)),
          radius: 20,
        );
      } catch (e) {
        print('Error loading image: $e');
        return _buildDefaultAvatar(entry);
      }
    } else {
      return _buildDefaultAvatar(entry);
    }
  }

  Widget _buildDefaultAvatar(JournalEntry entry) {
    return CircleAvatar(
      backgroundColor: entry.latitude != null ? Colors.blue : Colors.grey,
      child: Icon(
        entry.latitude != null ? Icons.location_on : Icons.note,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}