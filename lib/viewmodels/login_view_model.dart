import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/services/prefs_service.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  final _prefsService = locator<PrefsService>();
  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String?> login() async {
    setBusy(true);

    String username = usernameController.text;
    String password = passwordController.text;

    try {
      await _userService.login(username, password);
      setBusy(false);
      return null;
    } catch (e) {
      setBusy(false);
      return e.toString();
    }
  }

  /// Get current user approval status value.
  /// 0: Pending, 1: Approved, -1: Declined.
  Future<int> getApprovalStatus() async {
    return await _userService.getApprovalStatus();
  }

  /// Set user is approved or not to prefs.
  void setUserApproved(bool value) {
    _prefsService.setUserApproved(value);
  }
}