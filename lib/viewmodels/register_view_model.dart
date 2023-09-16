import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';

class RegisterViewModel extends BaseViewModel {
  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? userGroup;

  List<String> userGroups = ['pemindang', 'pabrik'];

  String? noEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harap diisi';
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harap diisi';
    }

    if (passwordController.text != confirmPasswordController.text) {
      return 'Password dan konfirmasi password tidak sama';
    }

    return null;
  }

  void autoFill() {
    usernameController.text = 'coba';
    fullNameController.text = 'Coba Coba';
    phoneController.text = '1234567890';
    emailController.text = 'coba@gmail.com';
    passwordController.text = 'coba1234';
    confirmPasswordController.text = 'coba1234';
  }

  Future<String?> register() async {
    setBusy(true);

    String username = usernameController.text;
    String fullName = fullNameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    try {
      await _userService.register(username, fullName, phone, email, userGroup!,
          password, confirmPassword);
    } catch (e) {
      setBusy(false);
      return e.toString();
    }

    try {
      await _userService.login(username, password);
    } catch (e) {
      setBusy(false);
      return e.toString();
    }

    try {
      await _userService.createPendingApproval();
      setBusy(false);
      return null;
    } catch (e) {
      setBusy(false);
      return e.toString();
    }
  }
}
