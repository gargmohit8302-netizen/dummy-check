import 'package:base_code/model/user_data_model.dart';
import 'package:base_code/module/home/home_controller.dart';
import 'package:base_code/module/home/home_screen.dart';
import 'package:base_code/module/users/user_list_controller.dart';
import 'package:base_code/module/users/user_model.dart';
import 'package:base_code/package/config_packages.dart';
import 'package:base_code/package/screen_packages.dart';

// ════════════════════════════════════════════════════════════════════════════
// USER LIST SCREEN — Real API Data
// ════════════════════════════════════════════════════════════════════════════
class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  void _onAddUser() {
    Get.to(() => const CreateUserScreen());
  }

  void _onHome() => Get.offAllNamed(AppRouter.homeScreen);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<UserListController>(UserListController());

    return Scaffold(
      backgroundColor: AppColor.bodyBackGroundColor,

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: _onHome,
          child: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.arrow_back_ios, color: AppColor.white, size: 20),
          ),
        ),
        title: const Text(
          'INDIFUNDED',
          style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
        actions: [
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: AppColor.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: AppColor.white),
                  onPressed: controller.reloadUsers,
                  tooltip: 'Refresh',
                )),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () {
                final hc = Get.put(HomeController());
                hc.logOutApiCall();
              },
              child: const Icon(Icons.logout, color: AppColor.white, size: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: _onHome,
              child: const Icon(Icons.home_outlined,
                  color: AppColor.white, size: 24),
            ),
          ),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User Management',
                    style: const TextStyle()
                        .normal24w600
                        .textColor(AppColor.black)),
                const SizedBox(height: 4),
                Text('View and reorder your platform users',
                    style: const TextStyle()
                        .normal14w400
                        .textColor(AppColor.gray500)),
                const SizedBox(height: 16),
                Container(height: 1, color: AppColor.borderColor),
              ],
            ),
          ),

          // Drag hint
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.primaryBlueColor,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColor.primaryColor.withOpacity(0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline,
                  size: 15, color: AppColor.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hold and drag the ≡ handle to reorder users.',
                  style: const TextStyle()
                      .normal14w400
                      .textColor(AppColor.primaryColor),
                ),
              ),
            ]),
          ),

          // User count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Obx(() => Text(
                  controller.isLoading.value
                      ? 'Loading users...'
                      : '${controller.users.length} Users',
                  style: const TextStyle()
                      .normal14w500
                      .textColor(AppColor.gray500),
                )),
          ),

          // ── Main content area ─────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoading.value && controller.users.isEmpty) {
                return const _LoadingView();
              }

              // Error state
              if (controller.hasError.value && controller.users.isEmpty) {
                return _ErrorView(
                  message: controller.errorMessage.value,
                  onRetry: controller.reloadUsers,
                );
              }

              // Empty state
              if (!controller.isLoading.value && controller.users.isEmpty) {
                return _EmptyView(onRefresh: controller.reloadUsers);
              }

              // Data — pull to refresh wraps the reorderable list
              return RefreshIndicator(
                onRefresh: controller.reloadUsers,
                color: AppColor.primaryColor,
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  buildDefaultDragHandles: false,
                  itemCount: controller.users.length,
                  onReorder: controller.onReorder,
                  proxyDecorator: _proxyDecorator,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    return _UserCard(
                      key: ValueKey(user.id),
                      user: user,
                      index: index,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),

      // ── FAB ────────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        heroTag: 'userListFAB',
        onPressed: _onAddUser,
        backgroundColor: AppColor.primaryColor,
        elevation: 6,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: AppColor.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      // ── Bottom Bar ─────────────────────────────────────────────────────────
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColor.white,
        elevation: 12,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _onHome,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryColor.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.home_rounded,
                      color: AppColor.white, size: 26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final elevation = Tween<double>(begin: 0, end: 10).evaluate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        return Material(
          elevation: elevation,
          borderRadius: BorderRadius.circular(12),
          shadowColor: AppColor.primaryColor.withOpacity(0.4),
          child: child,
        );
      },
      child: child,
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LOADING VIEW
// ════════════════════════════════════════════════════════════════════════════
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: 6,
      itemBuilder: (_, i) => _SkeletonCard(key: ValueKey('sk_$i')),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColor.gray100,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 13,
                width: 160,
                decoration: BoxDecoration(
                  color: AppColor.gray100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 11,
                width: 220,
                decoration: BoxDecoration(
                  color: AppColor.gray100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 22,
          decoration: BoxDecoration(
            color: AppColor.gray100,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ERROR VIEW
// ════════════════════════════════════════════════════════════════════════════
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.redColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.cloud_off_rounded,
                size: 48, color: AppColor.redColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
          Text('Failed to Load',
              style:
                  const TextStyle().normal16w600.textColor(AppColor.black)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle()
                  .normal14w400
                  .textColor(AppColor.gray500)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: AppColor.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// EMPTY VIEW
// ════════════════════════════════════════════════════════════════════════════
class _EmptyView extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.people_outline_rounded,
            size: 64, color: AppColor.gray300),
        const SizedBox(height: 16),
        Text('No users found',
            style:
                const TextStyle().normal16w600.textColor(AppColor.gray500)),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh'),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// USER CARD
// ════════════════════════════════════════════════════════════════════════════
class _UserCard extends StatelessWidget {
  final UserModel user;
  final int index;
  const _UserCard({super.key, required this.user, required this.index});

  static const _avatarColors = [
    AppColor.primaryColor,
    AppColor.purpleColor,
    AppColor.greenColor,
    Color(0xFFF59E0B),
    AppColor.redColor,
    Color(0xFF0891B2),
  ];

  Color get _statusColor {
    switch (user.status) {
      case UserStatus.active:
        return AppColor.greenColor;
      case UserStatus.failed:
        return AppColor.redColor;
      case UserStatus.pending:
        return const Color(0xFFF59E0B);
      case UserStatus.inactive:
        return AppColor.gray500;
    }
  }

  String get _statusLabel {
    switch (user.status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.failed:
        return 'Failed';
      case UserStatus.pending:
        return 'Pending';
      case UserStatus.inactive:
        return 'Inactive';
    }
  }

  IconData get _statusIcon {
    switch (user.status) {
      case UserStatus.active:
        return Icons.check_circle_rounded;
      case UserStatus.failed:
        return Icons.cancel_rounded;
      case UserStatus.pending:
        return Icons.access_time_rounded;
      case UserStatus.inactive:
        return Icons.remove_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final initials = user.name
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
    final sc = _statusColor;
    final sl = _statusLabel;
    final si = _statusIcon;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final u = UserData(
                  id: user.id,
                  email: user.email,
                  name: user.name,
                  isBlocked: user.isBlockedRaw ?? '',
                  walletBalance: user.walletBalance,
                  tradeLimit: user.tradeLimit,
                );
                Get.toNamed(AppRouter.editUSerScreen, arguments: u);
              },
              child: Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(initials,
                        style: TextStyle(
                          color: avatarColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: const TextStyle()
                                .normal14w600
                                .textColor(AppColor.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(user.email,
                            style: const TextStyle()
                                .normal14w400
                                .textColor(AppColor.gray500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: sc.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(si, size: 13, color: sc),
              const SizedBox(width: 4),
              Text(sl,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: sc)),
            ]),
          ),
          const SizedBox(width: 8),
          ReorderableDragStartListener(
            index: index,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor.gray100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.drag_handle_rounded,
                  size: 20, color: AppColor.gray500),
            ),
          ),
        ]),
      ),
    );
  }
}
