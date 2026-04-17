



import 'package:base_code/data/network/api_client.dart';
import 'package:base_code/data/network/dio_client.dart';
import 'package:base_code/model/walletdata.dart';

import '../../../package/config_packages.dart';

class TradeBookController extends GetxController {
  // Rxn is used so that the wallet data can be null initially.
  final walletData = Rxn<WalletData>();
  final isLoading = true.obs;


  Future<void> fetchWalletData(String id) async {
    try {
      final response = await callApi(dio.get("https://serve.indifunded.com/api/admin/wallet/$id"));
      if (response != null && response.statusCode == 200 && response.data != null) {
        WalletResponse walletResponse = WalletResponse.fromJson(response.data);
        walletData.value = walletResponse.data;
      }
    }  finally {
      isLoading.value = false;
    }
  }
}
