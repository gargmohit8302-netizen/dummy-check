import 'package:base_code/model/user_data_model.dart';
import 'package:base_code/module/home/home_controller.dart';
import 'package:base_code/package/config_packages.dart';

import '../../../components/app_loader.dart';
import '../../../data/network/api_client.dart';
import '../../../data/network/dio_client.dart';

class EditUSerController extends GetxController{
  Rx<UserData> user =   UserData().obs;
  Rx<TextEditingController> amountController = TextEditingController().obs;
  Rx<TextEditingController> tradeController = TextEditingController().obs;
  RxString amountString = "".obs;
  final homeController = Get.find<HomeController>();
  Future<void> editUserApiCall() async {
    try {
      final int amountValue = int.parse(amountController.value.text);

      final requestData = {
        "amount": amountValue,
      };
      final response = await callApi(
          dio.post(
            'https://serve.indifunded.com/api/admin/user/${user.value.id}',
            data: requestData,

          ),
          true
      );
      if (response != null && response.statusCode == 200) {
        amountString.value = "";
        homeController.currentPage.value=1;
        homeController.getUserDataApiCall();
        AppLoader().dismissLoader();
        Get.back();
      }  else {
        AppLoader().dismissLoader();
      }
    } on DioException {} catch (e) {
      AppLoader().dismissLoader();
    }
  }
  Future<void> settTradeLimit() async {
    try {
      final int amountValue = int.parse(tradeController.value.text);

      final requestData = {
        "trade_limit": amountValue,
      };
      final response = await callApi(
          dio.post(
            'https://serve.indifunded.com/api/admin/user/${user.value.id}',
            data: requestData,
          ),
          true
      );
      if (response != null && response.statusCode == 200) {
        amountString.value = "";
        homeController.currentPage.value=1;
        homeController.getUserDataApiCall();
        AppLoader().dismissLoader();
        Get.back();
      }  else {
        AppLoader().dismissLoader();
      }
    } on DioException {} catch (e) {
      AppLoader().dismissLoader();
    }
  }
  Future<void> deleteUserApiCall(String block) async {
    try {

      final requestData = {
        "isBlocked": block
      };
      final response = await callApi(
          dio.post(
            'https://serve.indifunded.com/api/admin/user/${user.value.id}',
            data: requestData,

          ),
          true
      );
      if (response != null && response.statusCode == 200) {
        amountString.value = "";
        homeController.currentPage.value=1;
        homeController.getUserDataApiCall();
        AppLoader().dismissLoader();
        Get.back();
      }  else {
        AppLoader().dismissLoader();
      }
    } on DioException {} catch (e) {
      AppLoader().dismissLoader();
    }
  }
}