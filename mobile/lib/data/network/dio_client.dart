import 'package:base_code/package/screen_packages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/foundation.dart';


import 'logger/PrettyDioLogger.dart';

late Dio dio;

BaseOptions baseOptions =
    BaseOptions(connectTimeout: const Duration(seconds: 30), receiveTimeout:  const Duration(seconds: 30));

const String baseUrl = kDebugMode
    ? 'https://paper-trading-backend-bz8w.onrender.com/'
    : 'https://paper-trading-backend-bz8w.onrender.com/';

// const String baseUrl = 'https://services.pickedsa.com/api/';

Future<void> dioSetUp({int? language}) async {
  dio = Dio(baseOptions);

  dio.interceptors.add(InterceptorsWrapper(onRequest:
      (RequestOptions option, RequestInterceptorHandler handler) async {
    var customHeaders = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Authorization': AppPref().token != null?'Bearer ${AppPref().token}':'',
      // 'Accept': 'application/json',
      // 'X-Requested-With': "XMLHttpRequest",
      // 'Authorization': 'Bearer ${AppPref().token}',
      // 'language': language ?? (AppPref().languageCode == "en" ? 1 : 2),
    };
    option.headers.addAll(customHeaders);
    handler.next(option);
  }));

  /// PreDioLogger to print api log in DEBUG mode
  if (!Foundation.kReleaseMode) {
    var logger = PrettyDioLogger(
      maxWidth: 232,
      requestHeader: true,
      requestBody: true,
    );
    dio.interceptors.add(logger);
  }
}
