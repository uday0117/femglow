import 'package:femglow/app/modules/insights/controllers/insights_controller.dart';
import 'package:get/get.dart';

class InsightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightsController>(() => InsightsController());
  }
}
