import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';
import 'package:perindo_bisnis_flutter/viewmodels/register_view_model.dart';
import 'package:perindo_bisnis_flutter/views/pending_view.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_button.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_dropdown.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({super.key});

  @override
  Widget builder(
      BuildContext context, RegisterViewModel viewModel, Widget? child) {
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
                          'Daftar akun baru',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        _buildForm(viewModel),
                        const SizedBox(height: 16),
                        MyButton(
                          text: 'Daftar',
                          backgroundColor: Colors.orange.shade300,
                          onPressed: () =>
                              _onPressedRegister(context, viewModel),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: viewModel.autoFill,
                  child: const SizedBox(height: 8, width: 8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();

  Widget _buildForm(RegisterViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          MyTextFormField(
            controller: viewModel.usernameController,
            labelText: 'Username',
            prefixIcon: const Icon(Icons.account_circle_outlined),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) => viewModel.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.fullNameController,
            labelText: 'Nama Lengkap',
            prefixIcon: const Icon(Icons.person_outline),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) => viewModel.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.phoneController,
            labelText: 'Nomor Ponsel',
            prefixIcon: const Icon(Icons.phone_outlined),
            prefixText: '+62',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) => viewModel.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.emailController,
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => viewModel.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyDropdown<String>(
            items: viewModel.userGroups,
            labelText: 'Jenis Pengguna',
            prefixIcon: const Icon(Icons.group_outlined),
            showSearchBox: false,
            itemAsString: (group) => MyUtils.capitalize(group),
            onChanged: (group) {
              if (group is String) {
                viewModel.userGroup = group;
              }
            },
            validator: (value) => MyUtils.mustSelectValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.passwordController,
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            obscureText: true,
            validator: (value) => viewModel.passwordValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.confirmPasswordController,
            labelText: 'Konfirmasi Password',
            prefixIcon: const Icon(Icons.lock_outline),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) => viewModel.passwordValidator(value),
          ),
        ],
      ),
    );
  }

  void _onPressedRegister(
      BuildContext context, RegisterViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);
    String? message = await viewModel.register();

    if (context.mounted) {
      Navigator.pop(context);

      if (message != null) {
        MyUtils.showErrorDialog(
          context,
          message: message,
        );

        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const PendingView(),
        ),
        (route) => false,
      );
    }
  }
}
