import 'package:femglow/app/modules/log_period/controllers/log_period_controller.dart';
import 'package:get/get.dart';

class LogPeriodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogPeriodController>(() => LogPeriodController());
  }
}
