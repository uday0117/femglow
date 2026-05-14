class SymptomEntry {
  final String id;
  final DateTime date;
  final String symptom;
  final String intensity; // 'mild', 'moderate', 'severe'
  final String? notes;

  SymptomEntry({
    required this.id,
    required this.date,
    required this.symptom,
    required this.intensity,
    this.notes,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'symptom': symptom,
      'intensity': intensity,
      'notes': notes,
    };
  }

  // Create from JSON
  factory SymptomEntry.fromJson(Map<String, dynamic> json) {
    return SymptomEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      symptom: json['symptom'],
      intensity: json['intensity'],
      notes: json['notes'],
    );
  }

  // Create a copy with modified fields
  SymptomEntry copyWith({
    String? id,
    DateTime? date,
    String? symptom,
    String? intensity,
    String? notes,
  }) {
    return SymptomEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      symptom: symptom ?? this.symptom,
      intensity: intensity ?? this.intensity,
      notes: notes ?? this.notes,
    );
  }
}
