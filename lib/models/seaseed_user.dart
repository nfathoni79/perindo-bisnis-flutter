class SeaseedUser {
  const SeaseedUser({
    required this.id,
    required this.userUuid,
    required this.walletUuid,
    required this.fullName,
    this.balance = 0,
  });

  factory SeaseedUser.fromJson(Map<String, dynamic> json) {
    return SeaseedUser(
      id: json['id'],
      userUuid: json['user_uuid'],
      walletUuid: json['wallet_uuid'],
      fullName: json['full_name'],
      balance: json['balance'] ?? 0,
    );
  }

  final int id;
  final String userUuid;
  final String walletUuid;
  final String fullName;
  final int balance;
}
