class PeriodEntry {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final String flowIntensity; // 'light', 'medium', 'heavy'
  final List<String> symptoms;
  final String? notes;

  PeriodEntry({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.flowIntensity,
    this.symptoms = const [],
    this.notes,
  });

  // Calculate period length in days
  int? get periodLength {
    if (endDate == null) return null;
    return endDate!.difference(startDate).inDays + 1;
  }

  // Check if period is ongoing
  bool get isOngoing => endDate == null;

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'flowIntensity': flowIntensity,
      'symptoms': symptoms,
      'notes': notes,
    };
  }

  // Create from JSON
  factory PeriodEntry.fromJson(Map<String, dynamic> json) {
    return PeriodEntry(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      flowIntensity: json['flowIntensity'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      notes: json['notes'],
    );
  }

  // Create a copy with modified fields
  PeriodEntry copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? flowIntensity,
    List<String>? symptoms,
    String? notes,
  }) {
    return PeriodEntry(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
    );
  }
}
