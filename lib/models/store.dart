class Store {
  const Store({
    required this.slug,
    required this.name,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      slug: json['kode_gerai'],
      name: json['store_name'],
    );
  }

  factory Store.fromJsonAlter(Map<String, dynamic> json) {
    return Store(
      slug: json['slug'],
      name: json['name'],
    );
  }

  final String slug;
  final String name;
}
