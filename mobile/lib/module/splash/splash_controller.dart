import 'package:base_code/package/config_packages.dart';
import 'package:base_code/package/screen_packages.dart';

class SplashController extends GetxController {
  final globalController = Get.find<GlobalController>();

  goNextScreen() async {

    3.delay(() async {
      if(AppPref().token != ""){
        Get.offNamed(AppRouter.userListScreen);
      }
      else{
        Get.offAllNamed(AppRouter.logInScreen);
      }
    });
  }
  @override
  void onReady() {
    super.onReady();
    goNextScreen();
  }
}
