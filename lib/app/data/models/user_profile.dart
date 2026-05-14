class UserProfile {
  final String name;
  final String? email;
  final DateTime? dateOfBirth;
  final int? averageCycleLength;
  final int? averagePeriodLength;
  final bool notificationsEnabled;
  final bool periodReminders;
  final bool ovulationReminders;
  final bool fertileWindowReminders;
  final String theme; // 'system', 'light', 'dark'

  UserProfile({
    required this.name,
    this.email,
    this.dateOfBirth,
    this.averageCycleLength,
    this.averagePeriodLength,
    this.notificationsEnabled = true,
    this.periodReminders = true,
    this.ovulationReminders = true,
    this.fertileWindowReminders = true,
    this.theme = 'system',
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'averageCycleLength': averageCycleLength,
      'averagePeriodLength': averagePeriodLength,
      'notificationsEnabled': notificationsEnabled,
      'periodReminders': periodReminders,
      'ovulationReminders': ovulationReminders,
      'fertileWindowReminders': fertileWindowReminders,
      'theme': theme,
    };
  }

  // Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      averageCycleLength: json['averageCycleLength'],
      averagePeriodLength: json['averagePeriodLength'],
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      periodReminders: json['periodReminders'] ?? true,
      ovulationReminders: json['ovulationReminders'] ?? true,
      fertileWindowReminders: json['fertileWindowReminders'] ?? true,
      theme: json['theme'] ?? 'system',
    );
  }

  // Create a copy with modified fields
  UserProfile copyWith({
    String? name,
    String? email,
    DateTime? dateOfBirth,
    int? averageCycleLength,
    int? averagePeriodLength,
    bool? notificationsEnabled,
    bool? periodReminders,
    bool? ovulationReminders,
    bool? fertileWindowReminders,
    String? theme,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      averagePeriodLength: averagePeriodLength ?? this.averagePeriodLength,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      periodReminders: periodReminders ?? this.periodReminders,
      ovulationReminders: ovulationReminders ?? this.ovulationReminders,
      fertileWindowReminders:
          fertileWindowReminders ?? this.fertileWindowReminders,
      theme: theme ?? this.theme,
    );
  }
}
