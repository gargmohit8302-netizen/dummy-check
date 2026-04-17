

import 'package:base_code/package/config_packages.dart';
import 'package:base_code/res/text_style.dart';

import '../res/color_schema.dart';

typedef OnValidation = dynamic Function(String? text);
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

class CommonTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool? obscureText;
  final OnValidation? validator;
  final Function(String?)? onChange;
  final Function(String?)? onFieldSubmitted;
  final Function()? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLine;
  final int? maxLength;
  final bool readOnly;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;
  const CommonTextField(
      {super.key,
      this.enable,
      this.onFieldSubmitted,
      this.prefixIcon,
      this.suffixIcon,
        this.maxLength,
      this.onTap,
      this.hintText = "",
      this.focusNode,
      this.controller,
      this.obscureText = false,
      this.readOnly = false,
      this.validator,
      this.onChange,
      this.inputFormatters,
      this.textInputAction,
      this.keyboardType,
      this.maxLine,
      this.autofillHints});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle().normal14w500.textColor(AppColor.black),
      autofillHints: autofillHints,
      autocorrect: true,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      maxLength: maxLength,
      cursorColor: AppColor.black,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      obscureText: obscureText!,
      maxLines: maxLine??1,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType ?? TextInputType.name,
      onChanged: (val) {
        if (onChange != null) {
          onChange!(val);
        }
      },

      validator: (val) {
        if (validator != null) {
          return validator!(val);
        } else {
          return null;
        }
      },
      enabled: enable ?? true,
      decoration: InputDecoration(
        fillColor: AppColor.textFieldFillColor,
        filled: true,
        counterText: "",
        isDense: true,
        focusedErrorBorder: OutlineInputBorder(
          borderSide:   const BorderSide(color: AppColor.gray200,width:1),

          borderRadius: BorderRadius.circular(14.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:   const BorderSide(color: AppColor.gray200,width: 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:   const BorderSide(color: AppColor.gray200,width: 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:   const BorderSide(color: AppColor.gray200,width: 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle().normal14w400.textColor(AppColor.gray500),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 24,
          maxHeight: 24,
          maxWidth: 36,
          minWidth: 36
        )
      ),
    );
  }
}
