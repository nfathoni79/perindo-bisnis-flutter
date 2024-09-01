import 'package:perindo_bisnis_flutter/models/bni_account.dart';

class BniTransfer {
  const BniTransfer({
    required this.id,
    required this.crn,
    required this.bankRef,
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    this.remark = '',
    required this.createdAt,
  });

  factory BniTransfer.fromJson(Map<String, dynamic> json) {
    return BniTransfer(
      id: json['id'],
      crn: json['crn'],
      bankRef: json['bank_ref'],
      fromAccount: BniAccount.fromJson(json['from_account']),
      toAccount: BniAccount.fromJson(json['to_account']),
      amount: json['amount'],
      remark: json['remark'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  final int id;
  final String crn;
  final String bankRef;
  final BniAccount fromAccount;
  final BniAccount toAccount;
  final int amount;
  final String remark;
  final DateTime createdAt;
}