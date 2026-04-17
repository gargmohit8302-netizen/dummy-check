// Status enum mapped from API "isBlocked" field:
// "init"  → active  (user registered, not evaluated)
// "pass"  → active  (kyc passed)
// "fail"  → failed  (kyc failed)
// null/other → inactive

enum UserStatus { active, failed, inactive, pending }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserStatus status;
  /// Raw `isBlocked` from API (`init` / `pass` / `fail`, etc.) for edit screen.
  final String? isBlockedRaw;
  final double walletBalance;
  final int tradeLimit;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    this.isBlockedRaw,
    this.walletBalance = 0.0,
    this.tradeLimit = 0,
  });

  /// Factory to build from the real API UserData model
  factory UserModel.fromApiData(Map<String, dynamic> json) {
    final dynamic blockedField = json['isBlocked'];
    final String raw = blockedField?.toString() ?? '';
    final String key = raw.toLowerCase().trim();
    UserStatus status;
    switch (key) {
      case 'pass':
        status = UserStatus.active;
        break;
      case 'fail':
        status = UserStatus.failed;
        break;
      case 'init':
        status = UserStatus.pending;
        break;
      default:
        if (blockedField is bool) {
          status = blockedField ? UserStatus.inactive : UserStatus.active;
        } else {
          status = UserStatus.inactive;
        }
    }
    final wb = json['walletBalance'];
    final double wallet = wb is num ? wb.toDouble() : double.tryParse('$wb') ?? 0.0;
    final tl = json['trade_limit'];
    final int trade = tl is int ? tl : int.tryParse('$tl') ?? 0;
    return UserModel(
      id: (json['_id'] ?? json['id'])?.toString() ?? '',
      name: () {
        final n = (json['name']?.toString() ?? '').trim();
        return n.isNotEmpty ? n : 'Unknown';
      }(),
      email: json['email']?.toString() ?? '',
      status: status,
      isBlockedRaw: raw.isNotEmpty ? raw : null,
      walletBalance: wallet,
      tradeLimit: trade,
    );
  }
}
