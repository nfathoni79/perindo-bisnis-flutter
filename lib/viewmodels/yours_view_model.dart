import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/store.dart';
import 'package:perindo_bisnis_flutter/services/auction_service.dart';
import 'package:perindo_bisnis_flutter/services/store_service.dart';
import 'package:stacked/stacked.dart';

class YoursViewModel extends MultipleFutureViewModel {
  static const String auctionsKey = 'auctions';

  final _storeService = locator<StoreService>();
  final _auctionService = locator<AuctionService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    auctionsKey: getYourAuctionsByStore,
  };

  bool get auctionsBusy => busy(auctionsKey);

  Store? get currentStore => _storeService.currentStore;
  List<Auction> get auctions => dataMap?[auctionsKey];

  Future<List<Store>> getStores() {
    return _storeService.getStores();
  }

  Future<List<Auction>> getYourAuctionsByStore() async {
    Store? store = _storeService.currentStore;

    if (store == null) {
      List<Store> stores = await _storeService.getStores();
      _storeService.setCurrentStore(stores[0]);
      store = _storeService.currentStore;
    }

    return _auctionService.getYourAuctionsByStore(store!.slug);
  }

  void setCurrentStore(Store store) {
    return _storeService.setCurrentStore(store);
  }
}