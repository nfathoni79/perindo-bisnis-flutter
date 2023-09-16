class Bank {
  const Bank({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  final int id;
  final String name;
  final String code;
}
