import 'package:perindo_bisnis_flutter/models/user.dart';

class Bid {
  const Bid({
    required this.id,
    required this.user,
    required this.value,
    required this.createdAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'],
      user: User.fromJson(json['user']),
      value: double.parse(json['price']).floor(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  final int id;
  final User user;
  final int value;
  final DateTime createdAt;
}
