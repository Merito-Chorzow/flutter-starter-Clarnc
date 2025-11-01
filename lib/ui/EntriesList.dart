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
      _entriesFuture = _apiService.getEntries();
    });
  }

  void _navigateToDetail(JournalEntry entry) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EntryDetailPage(
        entry: entry,
        onEntryDeleted: refreshEntries,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
      floatingActionButton: FloatingActionButton(
        onPressed: refreshEntries,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
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
          const Text(
            'Failed to load entries',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error.length > 100 ? 'Please check your connection' : error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
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
          const Text(
            'No entries yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Add your first entry using the + tab'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to add page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Change to add tab (index 1)
                // You might need to access the parent widget's state to change tab
                // For now, just show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Use the + tab to add entries'),
                  ),
                );
              });
            },
            child: const Text('Add First Entry'),
          ),
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
        return _buildEntryItem(entry);
      },
    );
  }

  Widget _buildEntryItem(JournalEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: _buildEntryLeading(entry),
        title: Text(
          entry.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.description.length > 60 
                ? '${entry.description.substring(0, 60)}...' 
                : entry.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatDate(entry.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: _buildEntryTrailing(entry),
        onTap: () => _navigateToDetail(entry),
      ),
    );
  }

  Widget _buildEntryLeading(JournalEntry entry) {
  // Try to load image if path exists
  if (entry.imagePath != null && entry.imagePath!.isNotEmpty) {
    try {
      final file = File(entry.imagePath!);
      // Check if file exists and is readable
      if (file.existsSync()) {
        return CircleAvatar(
          radius: 22,
          backgroundImage: FileImage(file),
          onBackgroundImageError: (exception, stackTrace) {
            print('Error loading image for ${entry.title}: $exception');
          },
        );
      } else {
        print('Image file does not exist at: ${entry.imagePath}');
        return _buildDefaultLeading(entry);
      }
    } catch (e) {
      print('Error loading image for ${entry.title}: $e');
      return _buildDefaultLeading(entry);
    }
  } else {
    return _buildDefaultLeading(entry);
  }
}

  Widget _buildDefaultLeading(JournalEntry entry) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: entry.latitude != null ? Colors.blue : Colors.grey,
      child: Icon(
        entry.latitude != null ? Icons.location_on : Icons.note,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildEntryTrailing(JournalEntry entry) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (entry.latitude != null)
          const Icon(Icons.location_on, color: Colors.green, size: 20),
        if (entry.imagePath != null && entry.imagePath!.isNotEmpty)
          const Icon(Icons.photo, color: Colors.blue, size: 16),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

 
void _deleteEntry(JournalEntry entry) async {
  try {
    final ApiService apiService = ApiService();
    await apiService.deleteEntry(entry.id);
    
    
    refreshEntries();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entry deleted successfully'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print('Error deleting entry: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting entry: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}