import 'package:perindo_bisnis_flutter/models/seaseed_user.dart';

class Transaction {
  const Transaction({
    required this.uuid,
    required this.fromUser,
    this.toUser,
    required this.amount,
    required this.type,
    this.remark = '',
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      uuid: json['trx_uuid'],
      fromUser: SeaseedUser.fromJson(json['from_user']),
      toUser: json['to_user'] != null
          ? SeaseedUser.fromJson(json['to_user'])
          : null,
      amount: json['amount'],
      type: json['type'],
      remark: json['remark'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  final String uuid;
  final SeaseedUser fromUser;
  final SeaseedUser? toUser;
  final int amount;
  final int type;
  final String remark;
  final DateTime createdAt;
}