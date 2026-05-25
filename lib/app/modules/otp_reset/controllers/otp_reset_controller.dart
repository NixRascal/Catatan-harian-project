import 'package:get/get.dart';

class OtpResetController extends GetxController {
  late final String email;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    email = (args is Map && args['email'] is String)
        ? args['email'] as String
        : 'emailmu';
  }
}
