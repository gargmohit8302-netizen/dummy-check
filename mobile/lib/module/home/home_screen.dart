import 'package:base_code/module/home/home_controller.dart';
import 'package:base_code/module/users/user_list_controller.dart';
import 'package:base_code/package/screen_packages.dart';
import 'package:http/http.dart' as http;
import '../../package/config_packages.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
@override
  void initState() {
    // TODO: implement initState
  WidgetsBinding.instance.addPostFrameCallback((a) async {
    controller.getUserDataApiCall();
    controller.scrollController.addListener(controller.scrollListener);
  });

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('INDIFUNDED',style: TextStyle(color: AppColor.white),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRouter.userListScreen),
              child: const Icon(Icons.groups_outlined, color: AppColor.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                controller.logOutApiCall();
              },
              child: const Icon(Icons.logout,color: AppColor.white,),
            ),
          )
        ],
      ),
      body: Obx(() => controller.userData.value.mainData?.data == null
          ? const Center(child: Text("NO DATA AVAILABLE"))
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.filterUsers(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search by name...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.searchText.value.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.clearSearch();
                      },
                    )
                        : null,
                  ),
                ),
              ),
        Expanded(
          child: Obx(() {
            final users = controller.filteredUsers.isNotEmpty
                ? controller.filteredUsers
                : controller.userData.value.mainData?.data ?? [];

            if (users.isEmpty) {
              return const Center(child: Text("No Data Available"));
            }

            return ListView.builder(
              controller: controller.scrollController,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(user.name ?? "", style: const TextStyle(color: Colors.black)),
                      subtitle: Text(user.email ?? ""),
                      trailing: user.isBlocked == "init"
                          ? SizedBox() // Show nothing if "init"
                          : Text(
                        user.isBlocked == "pass" ? "Pass" : "Failed",
                        style: TextStyle(
                          color: user.isBlocked == "pass" ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),

                      onTap: () {
                        Get.toNamed(AppRouter.editUSerScreen, arguments: user);
                      },
                    ),
                    const Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(color: AppColor.primaryColor,height: 0,),
                    )
                  ],
                );
              },
            );
          })),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeScreenFAB', // Unique hero tag here
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          // Navigate to the CreateUserScreen
          Get.to(() => const CreateUserScreen());
        },
        child: const Icon(Icons.add,color: AppColor.white,),
      ),
    );
  }
}




class TradeHistoryScreen extends StatelessWidget {
  final String userId;
  const TradeHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trade History - $userId')),
      body: ListView.builder(
        itemCount: 10, // Example trade count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Trade ${index + 1}'),
            subtitle: Text('Details of trade ${index + 1}'),
          );
        },
      ),
    );
  }
}

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HomeController controller = Get.put(HomeController());

  bool isLoading = false;

  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://serve.indifunded.com/api/admin/create/user');
    final response = await http.post(url, body: {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      controller.currentPage.value=1;
      await controller.getUserDataApiCall();
      if (Get.isRegistered<UserListController>()) {
        await Get.find<UserListController>().reloadUsers();
      }
      Get.back();
    } else {
      Get.snackbar('Error', 'Failed to create user');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: const Icon(CupertinoIcons.back,color: AppColor.white,)),
        title:  Text('Create User',style: const TextStyle().textColor(AppColor.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    ),
                onPressed: isLoading ? null : createUser,
                child: isLoading
                    ? const CircularProgressIndicator()
                    :  Text('Submit',style: const TextStyle().textColor(AppColor.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
