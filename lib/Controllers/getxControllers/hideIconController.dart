import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HideIconController extends GetxController {
  var hide = true.obs;

  void unHide() {
    hide(false);
  }

  void setHide() {
    hide(true);
  }
}
