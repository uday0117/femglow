import 'package:femglow/app/data/models/mood_entry.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MoodService extends GetxService {
  final storage = GetStorage();
  final RxList<MoodEntry> moods = <MoodEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMoods();
  }

  // Load moods from storage
  void _loadMoods() {
    final data = storage.read<List>('moods');
    if (data != null) {
      moods.value = data.map((m) => MoodEntry.fromJson(m)).toList();
    }
  }

  // Save moods to storage
  Future<void> _saveMoods() async {
    await storage.write('moods', moods.map((m) => m.toJson()).toList());
  }

  // Add a new mood entry
  Future<void> addMood(MoodEntry mood) async {
    moods.add(mood);
    await _saveMoods();
  }

  // Update an existing mood
  Future<void> updateMood(MoodEntry updatedMood) async {
    final index = moods.indexWhere((m) => m.id == updatedMood.id);
    if (index != -1) {
      moods[index] = updatedMood;
      await _saveMoods();
    }
  }

  // Delete a mood entry
  Future<void> deleteMood(String moodId) async {
    moods.removeWhere((m) => m.id == moodId);
    await _saveMoods();
  }

  // Get moods within a date range
  List<MoodEntry> getMoodsInRange(DateTime start, DateTime end) {
    return moods.where((mood) {
      return mood.date.isAfter(start.subtract(const Duration(days: 1))) &&
          mood.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get mood for a specific date
  MoodEntry? getMoodForDate(DateTime date) {
    try {
      return moods.firstWhere(
        (mood) =>
            mood.date.year == date.year &&
            mood.date.month == date.month &&
            mood.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  // Get mood statistics
  Map<String, int> getMoodStatistics({int days = 30}) {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final recentMoods = getMoodsInRange(startDate, DateTime.now());

    final stats = <String, int>{};
    for (var mood in recentMoods) {
      stats[mood.mood] = (stats[mood.mood] ?? 0) + 1;
    }

    return stats;
  }

  // Get most common emotions
  Map<String, int> getEmotionFrequency({int days = 30}) {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final recentMoods = getMoodsInRange(startDate, DateTime.now());

    final frequency = <String, int>{};
    for (var mood in recentMoods) {
      for (var emotion in mood.emotions) {
        frequency[emotion] = (frequency[emotion] ?? 0) + 1;
      }
    }

    return frequency;
  }
}
