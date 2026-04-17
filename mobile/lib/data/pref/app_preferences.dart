import 'package:base_code/package/config_packages.dart';

class AppPref {
  //region AppPref setup
  Future? _isPreferenceInstanceReady;
  late SharedPreferences _preferences;

  static final AppPref _instance = AppPref._internal();

  factory AppPref() => _instance;

  AppPref._internal() {
    _isPreferenceInstanceReady = SharedPreferences.getInstance().then((preferences) => _preferences = preferences);
  }

  Future? get isPreferenceReady => _isPreferenceInstanceReady;

  //endregion setup


  /// retrieve app current language
  String get languageCode => _preferences.getString('languageCode') ?? '';

  set languageCode(String value) => _preferences.setString('languageCode', value);

  /// retrieve app mode light/dark
  bool? get isDark => _preferences.getBool('isDark')??false;

  set isDark(bool? value) => _preferences.setBool('isDark', value ?? false);


  /// set token
  String? get token => _preferences.getString('token')??"";

  set token(String? value) => _preferences.setString('token', value ?? "");


  /// set login or not
  bool? get isLogin => _preferences.getBool('isLogin')??false;

  set isLogin(bool? value) => _preferences.setBool('isLogin', value ?? false);

  void clear() async {
    _preferences.clear();
  }
}
