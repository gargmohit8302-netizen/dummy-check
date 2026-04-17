

import 'package:base_code/package/screen_packages.dart';

import '../package/config_packages.dart';

class ValidationUtils {
  static bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return (!RegExp(pattern).hasMatch(value)) ? false : true;
  }
}


hideKeyboard() {
  Get.context?.let((it) {
    final currentFocus = FocusScope.of(it);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  });
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}

CachedNetworkImage getImageView(
    {required String finalUrl,
    double height = 40,
    double width = 40,
    fit = BoxFit.none,
    Decoration? shape,
    Color? color}) {
  return CachedNetworkImage(
    imageUrl: finalUrl,
    fit: fit,
    height: height,
    width: width,
    placeholder: (context, url) => Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColor.purpleGradient1,
        ),
      ),
    ),
    errorWidget: (context, url, error) => SizedBox(
      height: height,
      width: width,
      child: const Icon(Icons.error),
    ),
  );
}

class Throttler {
  Throttler({required this.throttleGapInMillis});

  final int throttleGapInMillis;
  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! >
          (throttleGapInMillis)) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}
