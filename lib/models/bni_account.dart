class BniAccount {
  const BniAccount({
    required this.id,
    required this.number,
    required this.name,
    required this.status,
    required this.isOgp,
    required this.lastBalance,
  });

  factory BniAccount.fromJson(Map<String, dynamic> json) {
    return BniAccount(
      id: json['id'],
      number: json['number'],
      name: json['name'],
      status: json['status'],
      isOgp: json['is_ogp'],
      lastBalance: json['last_balance'],
    );
  }

  final int id;
  final String number;
  final String name;
  final String status;
  final bool isOgp;
  final int lastBalance;
}