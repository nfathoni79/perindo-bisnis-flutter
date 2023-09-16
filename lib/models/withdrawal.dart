class Withdrawal {
  const Withdrawal({
    required this.uuid,
    required this.createdAt,
    required this.expiredAt,
    required this.status,
    this.paymentLink,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      uuid: json['uuid'],
      createdAt: DateTime.parse(json['created_at']),
      expiredAt: DateTime.parse(json['expired_at']),
      status: json['status'],
      paymentLink: json['payment_link'],
    );
  }

  final String uuid;
  final DateTime createdAt;
  final DateTime expiredAt;
  final String status;
  final String? paymentLink;
}
