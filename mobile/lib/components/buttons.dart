import 'package:base_code/package/screen_packages.dart';
import '../package/config_packages.dart';

class CommonAppButton extends StatelessWidget {
  final Function()? onTap;
  final ButtonType buttonType;

  final String? text;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final TextStyle? style;
  final double? borderRadius;
  final double? width;
  final bool? isShowIcon;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Widget? prefixIcon;

  const CommonAppButton(
      {super.key,
      this.onTap,
      this.buttonType = ButtonType.disable,
      this.text,
      this.color,
      this.icon,
      this.isShowIcon,
      this.height,
      this.textColor,
      this.style,
      this.borderRadius,
      this.width,
      this.boxShadow,
      this.border,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    Color background = const Color(0xffF6F1ED);
    switch (buttonType) {
      case ButtonType.enable:
        {
          background = color ?? AppColor.primaryColor;
        }
        break;
      case ButtonType.disable:
        {
          background = AppColor.primaryColor.withOpacity(.5);
        }
        break;
      case ButtonType.progress:
        break;
    }
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(borderRadius ?? 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius ?? 14),
        onTap: (buttonType == ButtonType.enable) ? (onTap ?? () {}) : () {},
        child: Container(
          height: height ?? 50,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(borderRadius ?? 14),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isShowIcon ?? false,
                child: Row(
                  children: [
                    icon??Container(),
                    const Gap(10),
                    //  Gap( isShowIcon == true ? 6.0 : 0),
                  ],
                ),
              ),
              if (buttonType != ButtonType.progress)
                Center(
                  child: Text(
                    text ?? "",
                    style: style ?? const TextStyle().normal16w400.textColor(textColor??AppColor.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
