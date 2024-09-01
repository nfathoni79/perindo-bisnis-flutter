import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/bni_account.dart';
import 'package:perindo_bisnis_flutter/models/bni_transfer.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';

class TransactionsViewModel extends MultipleFutureViewModel {
  static const String bniAccKey = 'bniAcc';
  static const String bniTrxKey = 'bniTrx';

  final _userService = locator<UserService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    bniAccKey: getBniAccount,
    bniTrxKey: getBniTransfers,
  };

  bool get bniAccBusy => busy(bniAccKey);
  bool get bniTrxBusy => busy(bniTrxKey);

  BniAccount get bniAccount => dataMap?[bniAccKey];
  List<BniTransfer> get bniTransfers => dataMap?[bniTrxKey];

  Future<BniAccount?> getBniAccount() {
    return _userService.getCurrentBniAccount();
  }

  Future<List<BniTransfer>> getBniTransfers() {
    return _userService.getBniTransfers();
  }
}