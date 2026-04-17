
import 'package:base_code/module/auth/login/login_screen.dart';
import 'package:base_code/module/auth/register/register_screen.dart';
import 'package:base_code/module/bottom/bottom_screen.dart';
import 'package:base_code/module/home/edit%20user/edit_user_screen.dart';
import 'package:base_code/module/home/home_screen.dart';
import 'package:base_code/module/home/tradbook/trade_book_screen.dart';
import 'package:base_code/module/users/user_list_screen.dart';
import 'package:base_code/package/screen_packages.dart';
import 'package/config_packages.dart';

class AppRouter {
  static const splashScreen = '/splashScreen';
  static const bottomScreen = '/bottomScreen';
  static const logInScreen = '/logInScreen';
  static const registerScreen = '/registerScreen';
  static const editUSerScreen = '/editUSerScreen';
  static const tradeBookScreen = '/tradeBookScreen';
  static const homeScreen = '/homeScreen';
  static const userListScreen = '/userListScreen';

  static List<GetPage> getPages = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: bottomScreen, page: () => const BottomBarScreen()),
    GetPage(name: logInScreen, page: () => const LoginScreen()),
    GetPage(name: registerScreen, page: () => const RegisterScreen()),
    GetPage(name: editUSerScreen, page: () => const EditUserScreen()),
    GetPage(name: tradeBookScreen, page: () => const TradeBookScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: userListScreen, page: () => const UserListScreen()),
  ];
}
