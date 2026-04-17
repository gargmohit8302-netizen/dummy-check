
import 'package:base_code/data/pref/app_preferences.dart';
import 'package:base_code/package/config_packages.dart';


abstract class AppColor {


  const AppColor._();
  static bool isDarkTheme() {
    return Get.isDarkMode;
  }

  static changeThemeMode() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      AppPref().isDark = false;
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      AppPref().isDark = true;
    }
  }




  static Color backGroundColor(){
    return isDarkTheme()
        ? DarkTheme.backGroundColor
        : LightTheme.backGroundColor;
  }

  static Color darkGray(){
    return isDarkTheme()
        ? DarkTheme.darkGray
        : LightTheme.darkGray;
  }

  static Color lightNatural(){
    return isDarkTheme()
        ? DarkTheme.lightNatural
        : LightTheme.lightNatural;
  }
  static Color gray(){
    return isDarkTheme()
        ? DarkTheme.gray
        : LightTheme.gray;
  }

  static Color cardColor(){
    return isDarkTheme()
        ? DarkTheme.cardColor
        : LightTheme.cardColor;
  }
  static Color cardTextColor(){
    return isDarkTheme()
        ? DarkTheme.cardTextColor
        : LightTheme.cardTextColor;
  }
  static Color orange(){
    return isDarkTheme()
        ? DarkTheme.orange
        : LightTheme.orange;
  }
  static Color purple(){
    return isDarkTheme()
        ? DarkTheme.purple
        : LightTheme.purple;
  }

  static const disableButtonColor = Color(0xFFADA9A6);

  ///app color
  static const primaryColor = Color(0xFF2962A1);
  static const primaryBlueColor = Color(0xFFE4F1F9);
  static const primaryColorLight = Color(0xFF196CFA);
  static const defaultIconColor = Color(0xFFA1A1AA);
  static const white = Color(0xFFFFFFFF);
  static const borderColor = Color(0xFFE4E4E7);
  static const bgBlueColor = Color(0xFFF6FBFF);

  static const greenColor = Color(0xFF67B64D);
  static const redColor = Color(0xFFEB5E4D);
  static const blueColor = Color(0xFF89B6E0);
  static const yellowColor = Color(0xffFBDA1B);

  static const purpleColor = Color(0xff7A87FB);
  static const black = Color(0xFF020408);
  static const gray500 = Color(0xFF71717A);
  static const textFieldFillColor = Color(0xFFF8FAFC);
  static const gray200 = Color(0xFFE4F1F9);
  static const unTabColor = Color(0xFF52525B);
  static const tableDataRow = Color(0xFFF9FAFB);
  static const gray300 = Color(0xFFD4D4D8);

  static const blue = Color(0xFF00008b);




  static const purpleGradient1 = Color(0xff776DF2);
  static const subBlack = Color(0xff615B5C);

  static const gray100 = Color(0xFFF4F4F5);
  static const logbook = Color(0xFFEAE8E8);
  static const gray400 = Color(0xFF94A3B8);
  static const gray600 = Color(0xFF475569);
  static const gray800 = Color(0xFF1E293B);
  static const bodyBackGroundColor = Color(0xFFF6FBFF);







}

class LightTheme {
  static const backGroundColor = Color(0xFF323234);
  static const darkGray = Color(0xFF979392);
  static const lightNatural = Color(0xFFF6F1ED);
  static const orange = Color(0xFFF37240);
  static const purple = Color(0xFF7B4B89);
  static const gray = Color(0xFF979392);
  static const cardColor = Color(0xFFF37240);
  static const cardTextColor = Color(0xFF323234);

}

class DarkTheme {
  static const backGroundColor = Color(0xFF323234);
  static const darkGray = Color(0xFF979392);
  static const lightNatural = Color(0xFFF6F1ED);
  static const orange = Color(0xFFF37240);
  static const purple = Color(0xFF7B4B89);
  static const gray = Color(0xFF979392);
  static const cardColor = Color(0xFFF37240);
  static const cardTextColor = Color(0xFF323234);

}