import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/models/user.dart';
import 'package:perindo_bisnis_flutter/services/prefs_service.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends MultipleFutureViewModel {
  static const String userKey = 'user';

  final _prefService = locator<PrefsService>();
  final _userService = locator<UserService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    userKey: getCurrentUser,
  };

  bool get userBusy => busy(userKey);

  User get user => dataMap?[userKey];

  Future<User?> getCurrentUser() {
    return _userService.getCurrentUser();
  }

  /// Log user out by clearing all prefs.
  void logout() {
    _prefService.clearPrefs();
  }
}