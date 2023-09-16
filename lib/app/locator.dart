import 'package:get_it/get_it.dart';
import 'package:perindo_bisnis_flutter/services/auction_service.dart';
import 'package:perindo_bisnis_flutter/services/lio_service.dart';
import 'package:perindo_bisnis_flutter/services/prefs_service.dart';
import 'package:perindo_bisnis_flutter/services/store_service.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefsService = await PrefsService.getInstance();
  locator.registerSingleton<PrefsService>(prefsService);

  final lioService = await LioService.getInstance();
  locator.registerSingleton<LioService>(lioService);

  locator.registerLazySingleton(() => AuctionService());
  locator.registerLazySingleton(() => StoreService());
  locator.registerLazySingleton(() => UserService());
}