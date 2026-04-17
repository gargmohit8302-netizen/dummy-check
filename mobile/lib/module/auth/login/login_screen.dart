import 'package:base_code/module/auth/login/login_controller.dart';
import 'package:base_code/package/config_packages.dart';
import 'package:base_code/package/screen_packages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put<LoginController>(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(

        automaticallyImplyLeading: false,
        title: Text("Login",style: const TextStyle().textColor(AppColor.white),),
        showFilterIcon: false,
         backgroundColor: AppColor.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 21, right: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email Address",
                style: const TextStyle().normal14w500.textColor(AppColor.black),
              ),
              const Gap(4),
              CommonTextField(
                hintText: "Rhebhek@gmail.com",
                controller: loginController.emailController.value,
                onChange: (val){
                  loginController.emailString.value = val??"";
                },
              ),
              const Gap(24),
              Text(
                "Password",
                style: const TextStyle().normal14w500.textColor(AppColor.black),
              ),
              const Gap(4),
              Obx(
                () => CommonTextField(
                  hintText: "Enter your password",
                  onChange: (val){
                    loginController.passString.value = val??"";
                  },
                  controller: loginController.passwordController.value,
                  obscureText: !loginController.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginController.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColor.black,
                    ),
                    onPressed: () {
                      loginController.isPasswordVisible.value =
                          !loginController.isPasswordVisible.value;
                    },
                  ),
                ),
              ),
              const Gap(30),
              Obx(
                ()=> CommonAppButton(
                  text: "Login",
                  textColor: AppColor.white,
                  onTap: () {
                    loginController.logInApiCall();
                    // Get.toNamed(AppRouter.bottomBarScreen);
                  },
                  color: AppColor.primaryColor,

                  buttonType: (loginController.emailString.value.isNotEmpty && loginController.passString.value.isNotEmpty)?ButtonType.enable:ButtonType.disable,
                  style: const TextStyle().normal14w600.textColor(
                        AppColor.white,
                      ),
                  borderRadius: 50,
                ),
              ),
              const Gap(40),
              // Center(
              //   child: RichText(
              //     text: TextSpan(
              //       text: "Don’t have an Account? ",
              //       style: const TextStyle()
              //           .normal14w400
              //           .textColor(AppColor.black),
              //       children: [
              //         TextSpan(
              //           recognizer: TapGestureRecognizer()
              //             ..onTap = () {
              //               Get.toNamed(AppRouter.registerScreen);
              //             },
              //           text: "Sign up here",
              //           style: const TextStyle()
              //               .normal14w500
              //               .textColor(AppColor.yellowColor),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
