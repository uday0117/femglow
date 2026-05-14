import 'package:femglow/app/modules/symptom_tracking/controllers/symptom_tracking_controller.dart';
import 'package:get/get.dart';

class SymptomTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SymptomTrackingController>(() => SymptomTrackingController());
  }
}
