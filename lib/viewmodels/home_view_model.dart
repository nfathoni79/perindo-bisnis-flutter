import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/seaseed_user.dart';
import 'package:perindo_bisnis_flutter/services/auction_service.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends MultipleFutureViewModel {
  static const String seaseedKey = 'seaseed';
  static const String auctionsKey = 'auctions';
  static const String processKey = 'process';

  final _userService = locator<UserService>();
  final _auctionService = locator<AuctionService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    seaseedKey: getSeaseedUser,
    auctionsKey: getRecentAuctions,
    processKey: processCost,
  };

  bool get seaseedBusy => busy(seaseedKey);
  bool get auctionsBusy => busy(auctionsKey);

  SeaseedUser? get seaseed => dataMap?[seaseedKey];
  List<Auction> get auctions => dataMap?[auctionsKey];

  Future<SeaseedUser?> getSeaseedUser() {
    return _userService.getCurrentSeaseedUser();
  }

  Future<List<Auction>> getRecentAuctions() {
    return _auctionService.getRecentAuctions();
  }

  Future<bool> processCost() {
    return _userService.processCost();
  }
}