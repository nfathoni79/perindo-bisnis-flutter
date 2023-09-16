import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:perindo_bisnis_flutter/app/config.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/api_exception.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/bank.dart';
import 'package:perindo_bisnis_flutter/models/deposit.dart';
import 'package:perindo_bisnis_flutter/models/seaseed_user.dart';
import 'package:perindo_bisnis_flutter/models/store.dart';
import 'package:perindo_bisnis_flutter/models/transaction.dart';
import 'package:perindo_bisnis_flutter/models/user.dart';
import 'package:perindo_bisnis_flutter/models/user_token.dart';
import 'package:perindo_bisnis_flutter/models/withdrawal.dart';
import 'package:perindo_bisnis_flutter/services/prefs_service.dart';

class LioService {
  static LioService? _instance;

  static Future<LioService> getInstance() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (packageInfo.packageName.endsWith('.local')) {
      debugPrint('Using Local API');
      _instance ??= LioService(Config.apiBaseUrlLocal,
          Config.apiClientIdLocal, Config.apiClientSecretLocal);
    } else if (packageInfo.packageName.endsWith('.dev')) {
      debugPrint('Using Dev API');
      _instance ??= LioService(Config.apiBaseUrlDev, Config.apiClientIdDev,
          Config.apiClientSecretDev);
    } else {
      debugPrint('Using Prod API');
      _instance ??= LioService(Config.apiBaseUrlProd, Config.apiClientIdProd,
          Config.apiClientSecretProd);
    }

    return _instance!;
  }

  LioService(this.baseUrl, this.clientId, this.clientSecret) {
    basicAuth = 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';
  }

  final _prefsService = locator<PrefsService>();

  final String baseUrl;
  final String clientId;
  final String clientSecret;
  String basicAuth = '';

  /// Login. Get token to access other APIs.
  Future<UserToken> getToken(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/o/token/'),
      headers: {
        HttpHeaders.authorizationHeader: basicAuth,
      },
      body: {
        'username': username,
        'password': password,
        'grant_type': 'password',
      },
    );

    if (response.statusCode == 200) {
      UserToken token = UserToken.fromJson(jsonDecode(response.body));
      _prefsService.setTokens(token.accessToken, token.refreshToken);

      return token;
    }

    String? message = jsonDecode(response.body)['error_description'];
    throw ApiException(message ?? 'Failed to get token.');
  }

  /// Get a new token if old token is expired.
  Future<UserToken> refreshToken() async {
    String? refreshToken = _prefsService.getRefreshToken();

    final response = await http.post(
      Uri.parse('$baseUrl/o/token/'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
    );

    if (response.statusCode == 200) {
      UserToken token = UserToken.fromJson(jsonDecode(response.body));
      _prefsService.setTokens(token.accessToken, token.refreshToken);

      return token;
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get a new token.';
    throw ApiException(message);
  }

  /// Register a new user.
  Future<bool> createUser(
      String username,
      String fullName,
      String phone,
      String email,
      String group,
      String password,
      String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/v2/register/'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'username': username,
        'email': email,
        'phone': phone,
        'full_name': fullName,
        'group': group,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to register.';
    throw ApiException(message);
  }

  /// Get current user.
  Future<User> getUser() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/user/v2/users/current/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return User.fromJson(body['user']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getUser();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get user.';
    throw ApiException(message);
  }

  /// Create pending Seaseed approval.
  Future<bool> createPendingApproval() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/seaseed/approvals/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      _prefsService.setUserApproved(false);
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createPendingApproval();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create approval';
    throw ApiException(message);
  }

  /// Get approval status.
  Future<int> getApprovalStatus() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/approvals/status/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['approval_status'];
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getApprovalStatus();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get status.';
    throw ApiException(message);
  }

  /// Get Seaseed Config
  Future<String> getSeaseedConfig(String key) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/configs/?key=$key'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return body['value'];
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getSeaseedConfig(key);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get config.';
    throw ApiException(message);
  }

  /// Create a new Seaseed User.
  Future<bool> createSeaseedUser() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/seaseed/users/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createSeaseedUser();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create Seaseed user';
    throw ApiException(message);
  }

  /// Get current Seaseed user.
  Future<SeaseedUser> getSeaseedUser() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/users/current/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return SeaseedUser.fromJson(body['user']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getSeaseedUser();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get Seaseed user.';
    throw ApiException(message);
  }

  /// Get other Seaseed users except current one.
  Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/users/others/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List users = body['users'];

      return users.map((user) => SeaseedUser.fromJson(user)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getOtherSeaseedUsers();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get other users.';
    throw ApiException(message);
  }

  /// Create a deposit.
  Future<Deposit> createDeposit(int amount) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/seaseed/deposits/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'amount': '$amount',
      },
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Deposit.fromJson(body['deposit']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createDeposit(amount);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create deposit.';
    throw ApiException(message);
  }

  /// Create a withdrawal.
  Future<Withdrawal> createWithdrawal(
      int amount, String email, String accountNo, String bankCode) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/seaseed/withdrawals/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'amount': '$amount',
        'email': email,
        'account_no': accountNo,
        'bank_code': bankCode,
      },
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Withdrawal.fromJson(body['withdrawal']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createWithdrawal(amount, email, accountNo, bankCode);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create withdrawal.';
    throw ApiException(message);
  }

  /// Get bank list for withdrawal.
  Future<List<Bank>> getBanks() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/banks/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List banks = body['banks'];

      return banks.map((bank) => Bank.fromJson(bank)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getBanks();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get banks.';
    throw ApiException(message);
  }

  /// Create a transfer.
  Future<bool> createTransfer(
      String toUserUuid, int amount, String remark) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/seaseed/transfers/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'to_user_uuid': toUserUuid,
        'amount': '$amount',
        'remark': remark,
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createTransfer(toUserUuid, amount, remark);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create transfer.';
    throw ApiException(message);
  }

  /// Get user's Seaseed transaction list.
  Future<List<Transaction>> getTransactions() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/transactions/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List transactions = body['transactions'];

      return transactions.map((trx) => Transaction.fromJson(trx)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getTransactions();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get transactions.';
    throw ApiException(message);
  }

  /// Get store/location list.
  Future<List<Store>> getStores() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/stores/?prefix=PI'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List stores = body['stores'];

      return stores.map((store) => Store.fromJsonAlter(store)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getStores();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get stores';
    throw ApiException(message);
  }

  /// Get auction list filtered by store.
  Future<List<Auction>> getAuctionsByStore(String slug) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/?store=$slug'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List auctions = body['auctions'];

      return auctions.map((auction) => Auction.fromJson(auction)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getAuctionsByStore(slug);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auctions.';
    throw ApiException(message);
  }

  /// Get your auction list filtered by store.
  Future<List<Auction>> getYourAuctionsByStore(String slug) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/?store=$slug&own=1'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List auctions = body['auctions'];

      return auctions.map((auction) => Auction.fromJson(auction)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getYourAuctionsByStore(slug);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auctions';
    throw ApiException(message);
  }

  /// Get recent auction list.
  Future<List<Auction>> getRecentAuctions() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/recent/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List auctions = body['auctions'];

      return auctions.map((auction) => Auction.fromJson(auction)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getRecentAuctions();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auctions.';
    throw ApiException(message);
  }

  /// Get a single auction by ID.
  Future<Auction> getAuctionById(int id) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/detail/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Auction.fromJson(jsonDecode(response.body)['auction']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getAuctionById(id);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auction.';
    throw ApiException(message);
  }

  /// Make a bid to a certain auction.
  Future<bool> createBid(int auctionId, int price) async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/lelang/v2/bids/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'auction_id': '$auctionId',
        'price': '$price',
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createBid(auctionId, price);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create bid.';
    throw ApiException(message);
  }

  /// Process pending admin cost for deposit and withdrawal.
  Future<bool> processCost() async {
    String? token = _prefsService.getAccessToken();
    if (token == null) throw ApiException('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/seaseed/process/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return processCost();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to process cost.';
    throw ApiException(message);
  }
}
