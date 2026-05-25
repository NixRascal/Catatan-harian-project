import 'package:get/get.dart';

import '../controllers/mood_controller.dart';

class MoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodController>(() => MoodController());
  }
}
