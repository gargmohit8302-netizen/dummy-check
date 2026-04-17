import 'package:base_code/data/network/api_client.dart';
import 'package:base_code/data/network/dio_client.dart';
import 'package:base_code/module/users/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserListController extends GetxController {
  // ── State ───────────────────────────────────────────────────────────────────
  RxList<UserModel> users = <UserModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool isPaginating = false.obs;

  // ── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    debugPrint('[UserList] Controller Initialized');
    fetchUsers();
  }

  // ── Fetch Users from API ────────────────────────────────────────────────────
  Future<void> fetchUsers({bool reset = true}) async {
    if (isLoading.value && reset) return;

    try {
      if (reset) {
        currentPage.value = 1;
        isLoading.value = true;
        hasError.value = false;
        errorMessage.value = '';
        debugPrint('[UserList] Fetching users (reset)...');
      } else {
        if (currentPage.value > totalPages.value) return;
        isPaginating.value = true;
        debugPrint('[UserList] Loading page ${currentPage.value}...');
      }

      final response = await callApi(
        dio.get(
          'https://serve.indifunded.com/api/admin/user?perPage=20&page=${currentPage.value}',
        ),
        false, // no loader
      );

      if (response?.statusCode == 200) {
        final body = response!.data;
        debugPrint('[UserList] API Success: ${response.statusCode}');

        if (body is! Map) {
          if (reset) {
            users.clear();
            hasError.value = true;
            errorMessage.value = 'Unexpected response format.';
          }
        } else {
          final map = Map<String, dynamic>.from(body);
          final dynamic d = map['data'];
          final List<dynamic> rawList = [];
          if (d is List) {
            rawList.addAll(d);
            totalPages.value = 1;
          } else if (d is Map) {
            final inner = Map<String, dynamic>.from(d);
            final innerData = inner['data'];
            if (innerData is List) {
              rawList.addAll(innerData);
            }
            final tp = inner['totalPages'];
            totalPages.value = tp is int ? tp : int.tryParse('$tp') ?? 1;
          }

          final fetched = rawList
              .whereType<Map>()
              .map((e) => UserModel.fromApiData(Map<String, dynamic>.from(e)))
              .toList();

          if (reset) {
            users.assignAll(fetched);
          } else {
            users.addAll(fetched);
          }

          currentPage.value++;
          debugPrint('[UserList] Loaded ${fetched.length} users. Total: ${users.length}');
        }
      } else {
        debugPrint('[UserList] API Error: ${response?.statusCode}');
        if (reset) {
          users.clear();
          hasError.value = true;
          errorMessage.value = 'Failed to load users (${response?.statusCode ?? "Unknown error"})';
        }
      }
    } catch (e, stack) {
      debugPrint('[UserList] Exception: $e');
      debugPrint('[UserList] Stack: $stack');
      if (reset) {
        users.clear();
        hasError.value = true;
        errorMessage.value = 'Something went wrong. Please check your connection.';
      }
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  /// Reload list from API (avoid shadowing [GetxController.refresh]).
  Future<void> reloadUsers() => fetchUsers(reset: true);

  // Load more (pagination)
  Future<void> loadMore() => fetchUsers(reset: false);

  // ── Drag & Drop Reorder ─────────────────────────────────────────────────────
  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final UserModel item = users.removeAt(oldIndex);
    users.insert(newIndex, item);
    debugPrint('[UserList] Reordered: ${item.name} moved to index $newIndex');
  }
}
