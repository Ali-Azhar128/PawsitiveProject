import 'package:get/get.dart';

class loginButtonController extends GetxController {
  final isLoading = false.obs;

  void setLoading() {
    isLoading(true);
  }

  void resetLoading() {
    isLoading(false);
  }
}
