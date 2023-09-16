import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/store.dart';
import 'package:perindo_bisnis_flutter/services/auction_service.dart';
import 'package:perindo_bisnis_flutter/services/store_service.dart';
import 'package:stacked/stacked.dart';

class AuctionsViewModel extends MultipleFutureViewModel {
  static const String storesKey = 'stores';
  static const String auctionsKey = 'auctions';

  final _storeService = locator<StoreService>();
  final _auctionService = locator<AuctionService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    storesKey: getStores,
    auctionsKey: getAuctionsByStore,
  };

  bool get storesBusy => busy(storesKey);
  bool get auctionsBusy => busy(auctionsKey);

  List<Store> get stores => dataMap?[storesKey];
  List<Auction> get auctions => dataMap?[auctionsKey];
  Store? get currentStore => _storeService.currentStore;

  Future<List<Store>> getStores() {
    return _storeService.getStores();
  }

  Future<List<Auction>> getAuctionsByStore() async {
    Store? store = _storeService.currentStore;

    if (store == null) {
      List<Store> stores = await _storeService.getStores();
      _storeService.setCurrentStore(stores[0]);
      store = _storeService.currentStore;
    }

    return _auctionService.getAuctionsByStore(store!.slug);
  }

  void setCurrentStore(Store store) {
    return _storeService.setCurrentStore(store);
  }
}