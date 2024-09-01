import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/bank.dart';
import 'package:perindo_bisnis_flutter/models/bni_account.dart';
import 'package:perindo_bisnis_flutter/models/bni_transfer.dart';
import 'package:perindo_bisnis_flutter/models/deposit.dart';
import 'package:perindo_bisnis_flutter/models/seaseed_user.dart';
import 'package:perindo_bisnis_flutter/models/transaction.dart';
import 'package:perindo_bisnis_flutter/models/user.dart';
import 'package:perindo_bisnis_flutter/models/user_token.dart';
import 'package:perindo_bisnis_flutter/models/withdrawal.dart';
import 'package:perindo_bisnis_flutter/services/lio_service.dart';

class UserService {
  final _lio = locator<LioService>();

  User? _currentUser;
  SeaseedUser? _currentSeaseedUser;
  List<SeaseedUser> _otherSeaseedUsers = [];
  List<Bank> _banks = [];
  List<Transaction> _transactions = [];
  BniAccount? _currentBniAccount;
  List<BniTransfer> _bniTransfers = [];

  User? get currentUser => _currentUser;
  SeaseedUser? get currentSeaseedUser => _currentSeaseedUser;
  List<SeaseedUser> get otherSeaseedUsers => _otherSeaseedUsers;
  List<Bank> get banks => _banks;
  List<Transaction> get transactions => _transactions;
  BniAccount? get currentBniAccount => _currentBniAccount;
  List<BniTransfer> get bniTransfers => _bniTransfers;

  Future<UserToken> login(String username, String password) async {
    return _lio.getToken(username, password);
  }

  Future<bool> register(String username, String fullName, String phone,
      String email, String group, String password, String confirmPassword) {
    return _lio.createUser(
        username, fullName, phone, email, group, password, confirmPassword);
  }

  Future<bool> createPendingApproval() async {
    return _lio.createPendingApproval();
  }

  Future<int> getApprovalStatus() async {
    return _lio.getApprovalStatus();
  }

  Future<String> getSeaseedConfig(String key)  async {
    return _lio.getSeaseedConfig(key);
  }

  Future<bool> createSeaseedUser() async {
    return _lio.createSeaseedUser();
  }

  Future<User?> getCurrentUser() async {
    _currentUser = await _lio.getUser();
    return _currentUser;
  }

  Future<SeaseedUser?> getCurrentSeaseedUser() async {
    _currentSeaseedUser = await _lio.getSeaseedUser();
    return _currentSeaseedUser;
  }

  Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    _otherSeaseedUsers = await _lio.getOtherSeaseedUsers();
    return _otherSeaseedUsers;
  }

  Future<Deposit> createDeposit(int amount) async {
    return _lio.createDeposit(amount);
  }

  Future<Withdrawal> createWithdrawal(
      int amount, String email, String accountNo, String bankCode) async {
    return _lio.createWithdrawal(amount, email, accountNo, bankCode);
  }

  Future<List<Bank>> getBanks() async {
    _banks = await _lio.getBanks();
    return _banks;
  }

  Future<bool> createTransfer(
      String toUserUuid, int amount, String remark) async {
    return _lio.createTransfer(toUserUuid, amount, remark);
  }

  Future<List<Transaction>> getTransactions() async {
    _transactions = await _lio.getTransactions();
    return _transactions;
  }

  Future<bool> processCost() async {
    return _lio.processCost();
  }

  Future<BniAccount?> getCurrentBniAccount() async {
    _currentBniAccount = await _lio.getBniAccount();
    return _currentBniAccount;
  }

  Future<List<BniTransfer>> getBniTransfers() async {
    _bniTransfers = await _lio.getBniTransfers();
    return _bniTransfers;
  }

  Future<int> getBniApprovalStatus() async {
    return _lio.getBniApprovalStatus();
  }
}
