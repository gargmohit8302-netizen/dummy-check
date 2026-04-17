import 'package:base_code/module/auth/register/register_controller.dart';
import 'package:base_code/package/config_packages.dart';
import 'package:base_code/package/screen_packages.dart';
import 'package:flutter/gestures.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = Get.put<RegisterController>(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(
        title: const Text("Register"),
        showFilterIcon: false,
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(left: 21.0, top: 30, bottom: 30, right: 21),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full Name",
                style: const TextStyle().normal14w500.textColor(AppColor.black),
              ),
              const Gap(4),
              CommonTextField(
                hintText: "Becca Ade",
                controller: controller.nameController.value,
                onChange: (val){
                  controller.nameString.value = val??"";
                },
              ),
              const Gap(24),
              Text(
                "Email Address",
                style: const TextStyle().normal14w500.textColor(AppColor.black),
              ),
              const Gap(4),
              CommonTextField(
                hintText: "Rhebhek@gmail.com",
                controller: controller.emailController.value,
                onChange: (val){
                  controller.emailString.value = val??"";
                },
              ),
              const Gap(24),
              Text(
                "Password",
                style: const TextStyle().normal14w500.textColor(AppColor.black),
              ),
              const Gap(4),
              Obx(
                    () =>
                    CommonTextField(
                      hintText: "Enter your password",
                      onChange: (val){
                        controller.passString.value = val??"";
                      },
                      controller: controller.passwordController.value,
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColor.black,
                        ),
                        onPressed: () {
                          controller.isPasswordVisible.value =
                          !controller.isPasswordVisible.value;
                        },
                      ),
                    ),
              ),
              const Gap(24),
              Text(
                "Confirm Password",
                style: const TextStyle().normal14w500.textColor(AppColor.black),
              ),
              const Gap(4),
              Obx(
                    () =>
                    CommonTextField(
                      hintText: "Enter your Confirm password",
                      controller: controller.confirmPasswordController.value,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      onChange: (val){
                        controller.conPassString.value = val??"";
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColor.black,
                        ),
                        onPressed: () {
                          controller.isConfirmPasswordVisible.value =
                          !controller.isConfirmPasswordVisible.value;
                        },
                      ),
                    ),
              ),
              const Gap(24),
              Obx(() {
                return CommonAppButton(
                  text: "Register",
                  onTap: () {
                    controller.registerApiCall();
                  },
                  textColor: AppColor.white,
                  color: AppColor.black,
                  buttonType: (controller.nameString.isNotEmpty &&
                      controller.emailString.isNotEmpty &&
                      controller.passString.isNotEmpty &&
                      controller.conPassString.isNotEmpty &&
                      controller.passString == controller.conPassString)
                      ? ButtonType.enable
                      : ButtonType.disable,
                  style: const TextStyle().normal14w600.textColor(
                    AppColor.white,
                  ),
                  borderRadius: 50,
                );
              }),
              const Gap(40),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Do you have an Account? ",
                    style: const TextStyle()
                        .normal14w400
                        .textColor(AppColor.black),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.back();
                          },
                        text: "login here",
                        style: const TextStyle()
                            .normal14w500
                            .textColor(AppColor.yellowColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
