import 'package:perindo_bisnis_flutter/utils/my_utils.dart';

class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.fullName,
    this.group = 'Pemindang',
    this.bniNum = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic> groups = json['groups'];

    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      fullName: json['full_name'],
      group: groups.isNotEmpty
          ? MyUtils.capitalize(groups[0]['name'])
          : 'Pemindang',
      bniNum: json['bninum'],
    );
  }

  final int id;
  final String username;
  final String email;
  final String phone;
  final String fullName;
  final String group;
  final String bniNum;
}
