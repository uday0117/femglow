class MoodEntry {
  final String id;
  final DateTime date;
  final String mood; // 'great', 'good', 'okay', 'bad', 'terrible'
  final List<String> emotions; // List of emotions felt that day
  final String? notes;

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    this.emotions = const [],
    this.notes,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'emotions': emotions,
      'notes': notes,
    };
  }

  // Create from JSON
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mood: json['mood'],
      emotions: List<String>.from(json['emotions'] ?? []),
      notes: json['notes'],
    );
  }

  // Create a copy with modified fields
  MoodEntry copyWith({
    String? id,
    DateTime? date,
    String? mood,
    List<String>? emotions,
    String? notes,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      emotions: emotions ?? this.emotions,
      notes: notes ?? this.notes,
    );
  }
}
