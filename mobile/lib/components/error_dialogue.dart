import 'package:base_code/package/screen_packages.dart';

import '../package/config_packages.dart';

void showErrorDialogue(String? msg) {
  if (msg == null || msg.isEmpty) {
    return;
  }

   showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return Theme(
          data: ThemeData(
           // backgroundColor: AppColor.lightNatural()
          ),
          child: Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 16, right: 8, top: 41),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          Text(
                            S.of(context).error.toUpperCase(),
                            style: const TextStyle().normal24w500.textColor(AppColor.backGroundColor()),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(16),
                          Text(
                            msg,
                            style: const TextStyle().normal16w500.textColor(AppColor.subBlack),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CommonAppButton(
                                buttonType: ButtonType.enable,
                                textColor: AppColor.white,
                                color: AppColor.backGroundColor(),
                                onTap: () async {
                                  Get.back();
                                },
                                text: S.of(context).ok.toUpperCase()),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );

}