import 'package:get/get.dart';

import '../controllers/otp_reset_controller.dart';

class OtpResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpResetController>(() => OtpResetController());
  }
}
