import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/store.dart';
import 'package:perindo_bisnis_flutter/services/lio_service.dart';

class StoreService {
  final _lio = locator<LioService>();

  List<Store> _stores = [];
  Store? _currentStore;

  List<Store> get stores => _stores;
  Store? get currentStore => _currentStore;

  Future<List<Store>> getStores() async {
    _stores = await _lio.getStores();
    return _stores;
  }

  void setCurrentStore(Store store) {
    _currentStore = store;
  }
}