
import 'package:base_code/package/config_packages.dart';
import 'package:base_code/package/screen_packages.dart';


extension TextStyleExtensions on TextStyle {
  // Weights
  TextStyle get bold => weight(FontWeight.w600);

  // Styles

  TextStyle get normal24w500 => customStyle(
      fontSize: 24,
      letterSpacing: 0.0,
      weight: FontWeight.w500,
      fontFamily: StringConst.fontFamily
  );

  TextStyle get normal16w500 => customStyle(
      fontSize: 16,
      letterSpacing: 0.0,
      weight: FontWeight.w500,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal16w600 => customStyle(
      fontSize: 16,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal16w400 => customStyle(
      fontSize: 16,
      letterSpacing: 0.0,
      weight: FontWeight.w400,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal10w500 => customStyle(
      fontSize: 10,
      letterSpacing: 0.0,
      weight: FontWeight.w500,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal18w600 => customStyle(
      fontSize: 18,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal12w500 => customStyle(
      fontSize: 12,
      letterSpacing: 0.0,
      weight: FontWeight.w400,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal12w600 => customStyle(
      fontSize: 12,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal12w400 => customStyle(
      fontSize: 12,
      letterSpacing: 0.0,
      weight: FontWeight.w400,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal24w600 => customStyle(
      fontSize: 24,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal20w600 => customStyle(
      fontSize: 20,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal42w600 => customStyle(
      fontSize: 42,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal18w700 => customStyle(
      fontSize: 18,
      letterSpacing: 0.0,
      weight: FontWeight.w700,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal14w400 => customStyle(
      fontSize: 14,
      letterSpacing: 0.0,
      weight: FontWeight.w400,
      fontFamily: StringConst.fontFamily
  );  TextStyle get normal15w400 => customStyle(
      fontSize: 15,
      letterSpacing: 0.0,
      weight: FontWeight.w400,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal14w600 => customStyle(
      fontSize: 14,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal14w500 => customStyle(
      fontSize: 14,
      letterSpacing: 0.0,
      weight: FontWeight.w500,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal18w400 => customStyle(
      fontSize: 18,
      letterSpacing: 0.0,
      weight: FontWeight.w400,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal20w200 => customStyle(
      fontSize: 20,
      letterSpacing: 0.0,
      weight: FontWeight.w200,
      fontFamily: StringConst.fontFamily
  );

  TextStyle get normal22w200 => customStyle(
      fontSize: 22,
      letterSpacing: 0.0,
      weight: FontWeight.w200,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal18w500 => customStyle(
      fontSize: 18,
      letterSpacing: 0.0,
      weight: FontWeight.w500,
      fontFamily: StringConst.fontFamily
  );
  TextStyle get normal30w600 => customStyle(
      fontSize: 30,
      letterSpacing: 0.0,
      weight: FontWeight.w600,
      fontFamily: StringConst.fontFamily
  );
  // TextStyle get normal18w600 => customStyle(
  //     fontSize: 18,
  //     letterSpacing: 0.0,
  //     weight: FontWeight.w600,
  //     fontFamily: "poppins"
  // );
  //


  /// Shortcut for color
  TextStyle textColor(Color v) => copyWith(color: v);

  /// Shortcut for fontWeight
  TextStyle weight(FontWeight v) => copyWith(fontWeight: v);

  /// Shortcut for fontSize
  TextStyle size(double v) => copyWith(fontSize: v);

  /// Shortcut for letterSpacing
  TextStyle letterSpace(double v) => copyWith(letterSpacing: v);

  TextStyle customStyle({
    required double letterSpacing,
    required double fontSize,
    required FontWeight weight,
    required String fontFamily,
  }) =>
      copyWith(
          letterSpacing: letterSpacing,
          fontSize: fontSize,
          fontWeight: weight,
          fontFamily: fontFamily
      );


}
