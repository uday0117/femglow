import 'package:femglow/app/modules/mood_tracking/controllers/mood_tracking_controller.dart';
import 'package:get/get.dart';

class MoodTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodTrackingController>(() => MoodTrackingController());
  }
}
