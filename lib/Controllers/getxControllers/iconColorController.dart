import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class IconColorController extends GetxController {
  var emailFocus = false.obs;
  var nameFocus = false.obs;
  var passFocus = false.obs;

  void setEmailFocus() {
    emailFocus(true);
  }

  void setUsernameFocus() {
    nameFocus(true);
  }

  void setPassFocus() {
    passFocus(true);
  }

  void resetEmailFocus() {
    emailFocus(false);
  }

  void resetUsernameFocus() {
    nameFocus(false);
  }

  void resetPassFocus() {
    passFocus(false);
  }
}
