import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/deposit.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';

class DepositViewModel extends FutureViewModel<int> {
  static const String getAdminCostKey = 'getAdminCost';
  static const String createDepositKey = 'createDeposit';

  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  Deposit? deposit;
  int adminCost = 0;
  int durianAdminCost = 0;
  int totalAmount = 0;

  @override
  Future<int> futureToRun() {
    return getAdminCost();
  }

  Future<int> getAdminCost() async {
    setBusyForObject(getAdminCostKey, true);
    String costText = await _userService.getSeaseedConfig('admin_cost');
    String durianText = await _userService.getSeaseedConfig('admin_cost_durianpay');
    adminCost = int.parse(costText);
    durianAdminCost = int.parse(durianText);
    totalAmount = adminCost + durianAdminCost;
    setBusyForObject(getAdminCostKey, false);

    return adminCost + durianAdminCost;
  }

  Future<Deposit?> createDeposit() async {
    setBusyForObject(createDepositKey, true);
    deposit = await _userService.createDeposit(totalAmount);
    setBusyForObject(createDepositKey, false);
    return deposit;
  }

  void calculateTotalAmount() {
    if (amountController.text != '') {
      totalAmount = int.parse(amountController.text) + adminCost + durianAdminCost;
    } else {
      totalAmount = adminCost + durianAdminCost;
    }

    notifyListeners();
  }
}