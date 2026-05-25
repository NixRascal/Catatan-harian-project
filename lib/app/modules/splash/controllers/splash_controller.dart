import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
