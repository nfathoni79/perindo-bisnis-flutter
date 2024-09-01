import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';
import 'package:perindo_bisnis_flutter/viewmodels/login_view_model.dart';
import 'package:perindo_bisnis_flutter/views/main_view.dart';
import 'package:perindo_bisnis_flutter/views/pending_view.dart';
import 'package:perindo_bisnis_flutter/views/register_view.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_button.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
        ),
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Image.asset('assets/images/perindo_bisnis.png'),
                ),
                Card(
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Masuk ke akun Anda',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        _buildForm(viewModel),
                        const SizedBox(height: 16),
                        MyButton(
                          text: 'Masuk',
                          backgroundColor: Colors.orange.shade300,
                          onPressed: () => _onPressedLogin(context, viewModel),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum punya akun?'),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterView())),
                              child: const Text('Daftar'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Lupa password?'),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Reset password'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  Widget _buildForm(LoginViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          MyTextFormField(
            controller: viewModel.usernameController,
            labelText: 'Username',
            prefixIcon: const Icon(Icons.person_outline),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.passwordController,
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
        ],
      ),
    );
  }

  void _onPressedLogin(BuildContext context, LoginViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);
    String? message = await viewModel.login();

    // Show error dialog if login fails.
    if (context.mounted && message != null) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(
        context,
        message: message,
      );

      return;
    }

    // Get approval status. If status is 1, user is approved.
    int approvalStatus = await viewModel.getBniApprovalStatus();
    viewModel.setUserApproved(approvalStatus > 0);

    // Go to PendingView is user is not approved yet, otherwise go to MainView.
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>
              approvalStatus <= 0 ? const PendingView() : const MainView(),
        ),
        (route) => false,
      );
    }
  }
}
