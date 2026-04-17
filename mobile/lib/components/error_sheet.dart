import 'package:base_code/package/screen_packages.dart';
import '../../package/config_packages.dart';

bool isInternetAvailable = true;

void showErrorSheet(String errorText, {Function()? onTap}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    context: Get.context!,
    isScrollControlled: true,
    builder: (context) => Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: AppColor.lightNatural(),
      ),
      padding: EdgeInsetsDirectional.only(start: 24, end: 24, top: 18, bottom: context.bottomPaddingIfNeeded(18)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              S.of(context).error.toUpperCase(),
              style: const TextStyle().normal20w600.textColor(AppColor.backGroundColor()),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "  •",
                style: const TextStyle().normal16w500.textColor(AppColor.subBlack),
                textAlign: TextAlign.start,
              ),
              const Gap(5),
              Expanded(
                child: Text(
                  errorText,
                  style: const TextStyle().normal16w500.textColor(AppColor.subBlack),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const Gap( 16),
          const Gap( 16),
          CommonAppButton(
              buttonType: ButtonType.enable,
              textColor: AppColor.white,
              color: AppColor.backGroundColor(),
              onTap: () async {
                Get.back();
              },
              text: S.of(context).cancel.toUpperCase())
        ],
      ),
    ),
  );
}
