import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/viewmodels/main_view_model.dart';
import 'package:stacked/stacked.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    return Scaffold(
      body: viewModel.getCurrentScreen(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.blue.shade50,
        indicatorColor: Colors.blue.shade200,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Lelang',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Anda',
          ),
        ],
        selectedIndex: viewModel.navbarIndex,
        onDestinationSelected: viewModel.onNavbarItemTapped,
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}
