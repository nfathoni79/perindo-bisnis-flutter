import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/viewmodels/profile_view_model.dart';
import 'package:perindo_bisnis_flutter/views/login_view.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Profil'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                ),
                viewModel.userBusy
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            viewModel.user.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(viewModel.user.username),
                          const SizedBox(height: 8),
                          Text(viewModel.user.group),
                        ],
                      ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Keluar'),
                    onTap: () {
                      viewModel.logout();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginView()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}
