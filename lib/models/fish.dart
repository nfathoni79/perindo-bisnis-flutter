class Fish {
  const Fish({
    required this.id,
    required this.name,
    this.price = 0,
  });

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['jenis_ikan_id'],
      name: json['nama_ikan'],
    );
  }

  final int id;
  final String name;
  final int price;
}
