import 'package:base_code/module/home/tradbook/tradbook_controller.dart';
import 'package:base_code/package/config_packages.dart';

class TradeBookScreen extends StatefulWidget {
  const TradeBookScreen({super.key});
  @override
  State<TradeBookScreen> createState() => _TradeBookScreenState();
}

class _TradeBookScreenState extends State<TradeBookScreen> {
  final controller = Get.put(TradeBookController());
  @override
  void initState() {
    super.initState();
    // Retrieve the id passed via Get.arguments
    final String id = Get.arguments as String;
    // Call fetchWalletData with the provided id after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchWalletData(id);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trade Book"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.walletData.value == null) {
          return const Center(child: Text("No Data Found"));
        }
        final wallet = controller.walletData.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Wallet Balance",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹${wallet.walletBalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Transactions List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: wallet.transactions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tx = wallet.transactions[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon Container based on transaction type
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: tx.type == "credit" ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                tx.type == "credit" ? Icons.arrow_downward : Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Transaction Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.description,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Amount: ₹${tx.amount.toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date: ${DateFormat('yyyy-MM-dd').format(tx.createdAt.toLocal())}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      "Time: ${DateFormat('hh:mm').format(tx.createdAt.toLocal())} ${DateFormat('a').format(tx.createdAt.toLocal())}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}