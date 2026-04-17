
import 'package:base_code/data/pref/app_preferences.dart';
import 'package:base_code/model/user_data_model.dart';
import 'package:base_code/package/config_packages.dart';

import '../../app_route.dart';
import '../../components/app_loader.dart';
import '../../data/network/api_client.dart';
import '../../data/network/dio_client.dart';


class HomeController extends GetxController {
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  final RxString searchText = ''.obs;
  RxList<UserData> filteredUsers = <UserData>[].obs;
  final TextEditingController searchController = TextEditingController();
  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    filterUsers('');
    FocusManager.instance.primaryFocus?.unfocus();
  }
  void filterUsers(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      filteredUsers.assignAll(userData.value.mainData?.data ?? []);
    } else {
      filteredUsers.assignAll(
        userData.value.mainData?.data
            ?.where((user) => user.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
            .toList() ??
            [],
      );
    }
  }
  Future<void> logOutApiCall() async {
    try {
      final response = await callApi(
          dio.post(
            'https://serve.indifunded.com/api/admin/logout',
          ),
          true
      );
      if (response != null && response.statusCode == 200) {
        AppPref().clear();
        Get.offAllNamed(AppRouter.logInScreen);
      }  else {
        AppLoader().dismissLoader();
      }
    } finally{

    }
  }

  Rx<UserDataModel> userData = UserDataModel().obs;


  Future<void> getUserDataApiCall({bool isPagination = false}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final response = await callApi(
        dio.get(
          'https://serve.indifunded.com/api/admin/user?perPage=10&page=${currentPage.value}',
        ),
        false,
      );

      if (response?.statusCode == 200) {
        final responseData = response?.data;
        UserDataModel newData = UserDataModel.fromJson(responseData);

        if (isPagination) {
          userData.value.mainData?.data?.addAll(newData.mainData?.data ?? []);
          userData.refresh(); // Notify observers of the update

        } else {
          userData.value = newData;
        }

        currentPage.value++;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      getUserDataApiCall(isPagination: true);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}