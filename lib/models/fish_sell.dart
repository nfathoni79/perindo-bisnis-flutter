import 'package:perindo_bisnis_flutter/models/fish.dart';

class FishSell {
  const FishSell({
    required this.id,
    required this.fish,
    this.quantity = 1,
  });

  factory FishSell.fromJson(Map<String, dynamic> json) {
    return FishSell(
      id: json['id'],
      fish: Fish.fromJson(json),
      quantity: double.parse(json['berat']),
    );
  }

  final int id;
  final Fish fish;
  final double quantity;
}
