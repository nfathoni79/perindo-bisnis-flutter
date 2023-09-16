import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/services/auction_service.dart';
import 'package:stacked/stacked.dart';

class AuctionDetailViewModel extends FutureViewModel<Auction?> {
  AuctionDetailViewModel({required this.auctionId});

  static const String createBidKey = 'createBid';

  final _auctionService = locator<AuctionService>();

  final formKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  final int auctionId;

  bool get createBidBusy => busy(createBidKey);
  Auction? get currentAuction => _auctionService.currentAuction;
  bool formEnabled = false;

  String? noEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harap diisi';
    }

    return null;
  }

  @override
  Future<Auction?> futureToRun() {
    return getAuctionById();
  }

  Future<Auction?> getAuctionById() async {
    Auction? auction = await _auctionService.getAuctionById(auctionId);
    formEnabled = auction!.status == 0 && auction.fishSells.length == 1;
    return auction;
  }

  Future<String?> createBid() async {
    setBusyForObject(createBidKey, true);

    int price = int.parse(priceController.text);
    double totalWeight = _auctionService.currentAuction!.totalWeight;

    try {
      await _auctionService.createBid(auctionId, (price * totalWeight).floor());
      setBusyForObject(createBidKey, false);
      return null;
    } catch (e) {
      setBusyForObject(createBidKey, false);
      return e.toString();
    }
  }
}