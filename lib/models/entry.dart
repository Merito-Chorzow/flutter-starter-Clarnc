class JournalEntry {
  final String id;
  final String title;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? imagePath;
  final DateTime createdAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.description,
    this.latitude,
    this.longitude,
    this.imagePath,
    DateTime? createdAt,
  }) : 
    id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      // MockAPI automatically adds 'createdAt' field, but we'll keep ours for consistency
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id']?.toString(),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      imagePath: json['imagePath'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}