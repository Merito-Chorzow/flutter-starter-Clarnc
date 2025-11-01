import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/entry.dart';
import 'package:flutter_application_1/services/APIservice.dart';
import 'package:flutter_application_1/ui/EntriesDetails.dart';
import 'dart:io';

class EntriesListPage extends StatefulWidget {
  const EntriesListPage({super.key});

  @override
  State<EntriesListPage> createState() => _EntriesListPageState();
}

class _EntriesListPageState extends State<EntriesListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<JournalEntry>> _entriesFuture;
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _entriesFuture = _loadEntries();
  }

  Future<List<JournalEntry>> _loadEntries() async {
    try {
      final entries = await _apiService.getEntries();
      _entries = entries;
      return entries;
    } catch (e) {
      throw e;
    }
  }

  void _refreshEntries() {
    setState(() {
      _entriesFuture = _loadEntries();
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
            onPressed: _refreshEntries,
          ),
        ],
      ),
      body: FutureBuilder<List<JournalEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
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
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshEntries,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
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
                  const Text('Tap the + button to add your first entry'),
                ],
              ),
            );
          } else {
            final entries = snapshot.data!;
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: entry.imagePath != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(entry.imagePath!)),
                          )
                        : CircleAvatar(
                            child: Icon(
                              entry.latitude != null ? Icons.location_on : Icons.note,
                            ),
                          ),
                    title: Text(entry.title),
                    subtitle: Text(
                      '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
                    ),
                    trailing: entry.latitude != null 
                        ? const Icon(Icons.location_on, color: Colors.green)
                        : null,
                    onTap: () => _navigateToDetail(entry),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}