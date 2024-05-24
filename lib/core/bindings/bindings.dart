import 'package:get/get.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';

class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
