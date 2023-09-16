import 'package:perindo_bisnis_flutter/models/bid.dart';
import 'package:perindo_bisnis_flutter/models/fish_sell.dart';
import 'package:perindo_bisnis_flutter/models/store.dart';

class Auction {
  const Auction({
    required this.id,
    required this.store,
    this.sellerName = '',
    this.totalWeight = 0,
    required this.fishSells,
    required this.bids,
    this.minBid = 0,
    this.maxBid = 0,
    this.lastBid = 0,
    this.status = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.expiredAt,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    List fishSellsJson = json['ikan'] as List;
    List<FishSell> fishSells = fishSellsJson
        .map((itemJson) => FishSell.fromJson(itemJson))
        .toList();

    List bidJson = json['menawarlelang'] as List;
    List<Bid> bids = bidJson.map((bidJson) => Bid.fromJson(bidJson)).toList();

    int status = 0;
    if (json['proses'] == 1 || json['status'] == 1) status = 1;
    if (json['is_all_done'] == 1) status = 2;

    return Auction(
      id: json['id'],
      store: Store.fromJson(json),
      sellerName: json['nelayan_name'],
      totalWeight: double.parse(json['berat_total']),
      fishSells: fishSells,
      bids: bids,
      minBid: json['min_bidding'].floor(),
      maxBid: json['max_bidding'].floor(),
      lastBid: double.parse(json['last_bidding']).floor(),
      status: status,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      expiredAt: DateTime.parse(json['exp_at']),
    );
  }

  final int id;
  final Store store;
  final String sellerName;
  final double totalWeight;
  final List<FishSell> fishSells;
  final List<Bid> bids;
  final int minBid;
  final int maxBid;
  final int lastBid;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime expiredAt;
}
