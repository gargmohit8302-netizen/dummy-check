import 'package:base_code/package/config_packages.dart';
import 'package:base_code/package/screen_packages.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put<SplashController>(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
       color: Colors.black
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 12,
            ),
            child: Image.asset(
              AppImage.splashIcon,
            ),
          ),
        ),
      ),
    );
  }
}
