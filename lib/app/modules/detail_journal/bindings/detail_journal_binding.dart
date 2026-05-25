import 'package:get/get.dart';

import '../controllers/detail_journal_controller.dart';

class DetailJournalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailJournalController>(() => DetailJournalController());
  }
}
