import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/services/lio_service.dart';

class AuctionService {
  final _lio = locator<LioService>();

  List<Auction> _recentAuctions = [];
  List<Auction> _auctionsByStore = [];
  List<Auction> _yourAuctionsByStore = [];
  Auction? _currentAuction;

  List<Auction> get recentAuctions => _recentAuctions;
  List<Auction> get auctionsByStore => _auctionsByStore;
  List<Auction> get yourActionsByStore => _yourAuctionsByStore;
  Auction? get currentAuction => _currentAuction;

  Future<List<Auction>> getRecentAuctions() async {
    _recentAuctions = await _lio.getRecentAuctions();
    return _recentAuctions;
  }

  Future<List<Auction>> getAuctionsByStore(String slug) async {
    _auctionsByStore = await _lio.getAuctionsByStore(slug);
    return _auctionsByStore;
  }

  Future<List<Auction>> getYourAuctionsByStore(String slug) async {
    _yourAuctionsByStore = await _lio.getYourAuctionsByStore(slug);
    return _yourAuctionsByStore;
  }

  Future<Auction?> getAuctionById(int id) async {
    _currentAuction = await _lio.getAuctionById(id);
    return _currentAuction;
  }

  Future<bool> createBid(int auctionId, int price) async {
    return _lio.createBid(auctionId, price);
  }
}