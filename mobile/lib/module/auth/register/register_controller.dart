import 'package:base_code/package/config_packages.dart';

import '../../../app_route.dart';
import '../../../components/app_loader.dart';
import '../../../data/network/api_client.dart';
import '../../../data/network/dio_client.dart';
import '../../../data/pref/app_preferences.dart';

class RegisterController extends GetxController{
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> passwordController  = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController  = TextEditingController().obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isCheck = false.obs;
  RxBool isConfirmCheck = false.obs;
  RxString nameString = "".obs;
  RxString emailString = "".obs;
  RxString passString = "".obs;
  RxString conPassString = "".obs;
  Future<void> registerApiCall() async {
    try {
      final requestData = {
        "name":nameString.value,
        "email":emailString.value.trim(),
        "password":passString.value.trim(),
      };
      final response = await callApi(
          dio.post(
            'https://serve.indifunded.com/api/admin/register',
            data: requestData,

          ),
          true
      );
      if (response != null && response.statusCode == 201) {
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