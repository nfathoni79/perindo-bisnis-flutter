import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/models/store.dart';
import 'package:perindo_bisnis_flutter/viewmodels/auctions_view_model.dart';
import 'package:perindo_bisnis_flutter/views/auction_detail_view.dart';
import 'package:perindo_bisnis_flutter/views/profile_view.dart';
import 'package:perindo_bisnis_flutter/views/widgets/auction_card.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_dropdown.dart';
import 'package:stacked/stacked.dart';

class AuctionsView extends StackedView<AuctionsViewModel> {
  const AuctionsView({super.key});

  @override
  Widget builder(
      BuildContext context, AuctionsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Lelang'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ProfileView())),
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.initialise,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              MyDropdown<Store>(
                items: const [],
                asyncItems: (_) => viewModel.getStores(),
                itemAsString: (store) => store.name,
                compareFn: (a, b) => a.slug == b.slug,
                prefixIcon: const Icon(Icons.store_outlined),
                selectedItem: viewModel.currentStore,
                onChanged: (store) {
                  if (store is Store) {
                    viewModel.setCurrentStore(store);
                    viewModel.initialise();
                  }
                },
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildAuctionSection(context, viewModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  AuctionsViewModel viewModelBuilder(BuildContext context) =>
      AuctionsViewModel();

  Widget _buildAuctionSection(
      BuildContext context, AuctionsViewModel viewModel) {
    if (viewModel.auctionsBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.auctions.isEmpty) {
      return const Text('Belum ada lelang');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: viewModel.auctions
          .map((auction) => AuctionCard(
                auction: auction,
                withStore: false,
                onDetailPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AuctionDetailView(auctionId: auction.id),
                )),
              ))
          .toList(),
    );
  }
}
