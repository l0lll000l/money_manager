import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Athul'.obs;
  final RxString email = 'athul@example.com'.obs;
  final RxString profileImageUrl = ''.obs;

  void editProfile() {
    // Edit profile logic
    Get.snackbar(
      'Coming Soon',
      'Edit profile feature is under development.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
