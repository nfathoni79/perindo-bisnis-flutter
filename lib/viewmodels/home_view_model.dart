import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/bni_account.dart';
import 'package:perindo_bisnis_flutter/services/auction_service.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends MultipleFutureViewModel {
  static const String auctionsKey = 'auctions';
  static const String bniKey = 'bni';

  final _userService = locator<UserService>();
  final _auctionService = locator<AuctionService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    auctionsKey: getRecentAuctions,
    bniKey: getBniAccount,
  };

  bool get auctionsBusy => busy(auctionsKey);
  bool get bniBusy => busy(bniKey);

  List<Auction> get auctions => dataMap?[auctionsKey];
  BniAccount? get bni => dataMap?[bniKey];

  Future<List<Auction>> getRecentAuctions() {
    return _auctionService.getRecentAuctions();
  }

  Future<BniAccount?> getBniAccount() {
    return _userService.getCurrentBniAccount();
  }
}