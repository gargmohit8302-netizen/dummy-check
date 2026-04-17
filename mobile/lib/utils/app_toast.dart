import 'package:base_code/package/config_packages.dart';
import 'package:base_code/package/screen_packages.dart';

class AppToast{
  void showAppToast(String? msg) {
    if (msg == null || msg.isEmpty) {
      return;
    }
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      //backgroundColor: themeData(AppColor.yellowColor, AppColor.purple300),
      textColor: AppColor.white,
      fontSize: 14,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void showErrorToast(String? msg) {
    if (msg == null || msg.isEmpty) {
      return;
    }
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: AppColor.redColor,
      textColor: AppColor.white,
      fontSize: 14,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
