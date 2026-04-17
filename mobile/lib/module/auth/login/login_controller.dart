import 'package:base_code/app_route.dart';
import 'package:base_code/components/app_loader.dart';
import 'package:base_code/data/pref/app_preferences.dart';
import 'package:base_code/package/config_packages.dart';

import '../../../data/network/api_client.dart';
import '../../../data/network/dio_client.dart';

class LoginController extends GetxController{
Rx<TextEditingController> emailController = TextEditingController().obs;
Rx<TextEditingController> passwordController  = TextEditingController().obs;
RxBool isPasswordVisible = false.obs;
RxBool isCheck = false.obs;
RxString emailString ="".obs;
RxString passString ="".obs;
Future<void> logInApiCall() async {
  try {
    // AppLoader().showLoader();
    final requestData = {
      "email":emailString.value.trim(),
      "password":passString.value.trim()
    };
    final response = await callApi(
      dio.post(
        'https://serve.indifunded.com/api/admin/login',
        data: requestData,

      ),
      true
    );
    if (response != null && response.statusCode == 200) {
      final responseData = response.data;
      AppPref().token = responseData["data"]["token"];
      AppLoader().dismissLoader();
      Get.offAllNamed(AppRouter.bottomScreen);
    }  else {
      AppLoader().dismissLoader();
    }
  } on DioException {} catch (e) {
    AppLoader().dismissLoader();
  }
}

}