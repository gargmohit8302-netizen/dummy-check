
import 'package:base_code/module/home/edit%20user/edit_user_controller.dart';
import 'package:base_code/package/screen_packages.dart';
import '../../../package/config_packages.dart';

class EditUserScreen extends StatefulWidget {

  const EditUserScreen({super.key,});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final controller = Get.put<EditUSerController>(EditUSerController());

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      controller.user.value = Get.arguments;
      controller.amountController.value.text =
          controller.user.value.walletBalance.toString();
      controller.amountString.value =
          controller.user.value.walletBalance.toString();
      controller.tradeController.value.text =
          controller.user.value.tradeLimit?.toString() ?? "";


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: const Icon(CupertinoIcons.back,color: AppColor.white,)),
        title: Obx(() {
          return Text(controller.user.value.name ?? "",style: const TextStyle(color: AppColor.white),);
        }),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Gap(5),
            Obx(
            ()=> RichText(text: TextSpan(

                children: [
                  TextSpan(
                    text: "Email : ",
                    style: const TextStyle().normal16w600.textColor(AppColor.black),
                  ),
                  TextSpan(
                    text: controller.user.value.email,
                    style: const TextStyle().normal15w400.textColor(AppColor.black)
                  ),

                ]
              )),
            ),
            const Gap(5),
            Obx(
                  ()=> RichText(text: TextSpan(

                  children: [
                    TextSpan(
                      text: "password : ",
                      style: const TextStyle().normal16w600.textColor(AppColor.black),
                    ),
                    TextSpan(
                        text: controller.user.value.password,
                        style: const TextStyle().normal15w400.textColor(AppColor.black)
                    ),

                  ]
              )),
            ),
            const Gap(5),
            Obx(()=> RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: "Wallet balance : ",
                    style: const TextStyle().normal16w600.textColor(AppColor.black),
                  ),
                  TextSpan(
                    text: controller.user.value.walletBalance?.toStringAsFixed(2),
                    style: const TextStyle().normal15w400.textColor(AppColor.black)
                  ),

                ]
              )),
            ),
            Obx(()=> RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: "Trade Limit : ",
                    style: const TextStyle().normal16w600.textColor(AppColor.black),
                  ),
                  TextSpan(
                    text: controller.user.value.tradeLimit?.toStringAsFixed(2),
                    style: const TextStyle().normal15w400.textColor(AppColor.black)
                  ),

                ]
              )),
            ),

            const Gap(10),
            Text(
              "Add new balance",
              style: const TextStyle().normal16w600.textColor(AppColor.black),
            ),
            const Gap(4),
            Obx(() {
              return CommonTextField(
                hintText: "",
                controller: controller.amountController.value,
                onChange: (val) {
                  controller.amountString.value = val ?? "";
                },
              );
            }),
            const Gap(20),

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    GestureDetector(
      onTap: (){
        String id=controller.user.value.id??"";
        Get.toNamed(AppRouter.tradeBookScreen, arguments: id);

      },
      child: Container(

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text("TradeBook",style: const TextStyle().normal18w600,)),
    ),
    ElevatedButton(
      onPressed: () {
        Get.defaultDialog(
          title: "Set Trade Limit",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.tradeController.value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter trade limit",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back(); // Close the dialog
                      await controller.settTradeLimit(); // Call API
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                    ),
                    child: const Text("Set", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.white,
        side: const BorderSide(color: AppColor.primaryColor),
      ),
      child: const Text(
        'Set Trade Limit',
        style: TextStyle(color: AppColor.primaryColor),
      ),
    )

  ],
),
            const Spacer(),

            Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {

                  await    controller.editUserApiCall();

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.white,
                      side: const BorderSide(
                          color: AppColor.primaryColor
                      )),
                  child: const Text('Add balance', style: TextStyle(color: AppColor.primaryColor),),
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: () async {
                    Get.defaultDialog(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      backgroundColor: AppColor.white,
                      title: 'Confirmation',
                      middleText: 'Give them Exam result',
                      middleTextStyle: const TextStyle().normal16w400.textColor(AppColor.black),
                      textCancel: 'Failed',
                      textConfirm: 'Pass',
                      buttonColor: AppColor.primaryColor,
                      confirmTextColor: AppColor.white,
                      onConfirm: () async {
                        Get.back();
                        await controller.deleteUserApiCall("pass"); // Send "pass"
                      },
                      onCancel: () {
                        Get.back();
                        controller.deleteUserApiCall("fail"); // Send "fail"
                      },
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            controller.deleteUserApiCall("init"); // Send "init" on reset
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          child: const Text("Reset", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                  child: const Text(
                    "Pass & Failed User",
                    style: TextStyle(color: AppColor.white),
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetVirtualAmountDialog() {
    final tradeLimitController = TextEditingController();

    return AlertDialog(
      title: const Text('Set Trade Limit / Reset Virtual Amount'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: tradeLimitController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter Trade Limit'),
          ),
        ],
      ),
      actions: [
        // Reset Button


        // Set Button
        ElevatedButton(
          onPressed: () {

            Get.back();
          },
          child: const Text('Set'),
        ),
      ],
    );
  }

  Widget _buildTradeLimitDialog() {
    final tradeLimitController = TextEditingController();
    return AlertDialog(
      title: const Text('Set Trade Limit'),
      content: TextField(
        controller: tradeLimitController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Enter Trade Limit'),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            // Perform Trade Limit Action
            Get.back();
            Get.snackbar(
                'Success', 'Trade Limit Set to ${tradeLimitController.text}');
          },
          child: const Text('Set Limit'),
        ),
      ],
    );
  }
}
