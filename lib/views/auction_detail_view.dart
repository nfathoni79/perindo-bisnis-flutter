import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/fish_sell.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';
import 'package:perindo_bisnis_flutter/viewmodels/auction_detail_view_model.dart';
import 'package:perindo_bisnis_flutter/views/widgets/auction_prop_row.dart';
import 'package:perindo_bisnis_flutter/views/widgets/bid_row.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_button.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';

class AuctionDetailView extends StackedView<AuctionDetailViewModel> {
  const AuctionDetailView({
    super.key,
    required this.auctionId,
  });

  final int auctionId;

  @override
  Widget builder(
      BuildContext context, AuctionDetailViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Detail Lelang'),
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.initialise,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: viewModel.isBusy
                      ? const Center(child: CircularProgressIndicator())
                      : _buildAuctionSection(context, viewModel),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: viewModel.formKey,
                        child: MyTextFormField(
                          controller: viewModel.priceController,
                          labelText: 'Harga/Kg',
                          prefixIcon: const Icon(Icons.sell_outlined),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          smallPadding: true,
                          validator: (value) =>
                              viewModel.noEmptyValidator(value),
                          enabled: viewModel.formEnabled,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MyButton(
                      text: 'Tawar',
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.blue.shade50,
                      onPressed: _onPressedBid(context, viewModel),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  AuctionDetailViewModel viewModelBuilder(BuildContext context) =>
      AuctionDetailViewModel(auctionId: auctionId);

  Widget _buildAuctionSection(
      BuildContext context, AuctionDetailViewModel viewModel) {
    Auction? auction = viewModel.data;

    if (auction == null) return const Text('Tidak ada lelang');

    String statusText = 'Berlangsung';
    if (auction.status == 1) statusText = 'Proses pemenang';
    if (auction.status >= 2) statusText = 'Selesai';

    String fishText = '';
    double totalQuantity = 0;

    for (var i = 0; i < auction.fishSells.length; i++) {
      FishSell fishSell = auction.fishSells[i];
      String fishName = fishSell.fish.name;
      String fishWeight = '(${MyUtils.formatNumber(fishSell.quantity)} Kg)';
      totalQuantity += fishSell.quantity;

      if (i >= auction.fishSells.length - 1) {
        fishText += '$fishName $fishWeight';
      } else {
        fishText += '$fishName $fishWeight, ';
      }
    }

    String minPriceLabel = 'Harga awal';
    double minPriceValue = auction.minBid.toDouble();
    if (auction.fishSells.length == 1) {
      minPriceLabel = 'Harga awal/Kg';
      minPriceValue = auction.minBid / totalQuantity;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        AuctionPropRow(
          icon: Icon(
            Icons.tag,
            color: Colors.blue.shade800,
          ),
          title: 'ID',
          value: '${auction.id}',
        ),
        const Divider(),
        AuctionPropRow(
          icon: Icon(
            Icons.schedule,
            color: Colors.green.shade800,
          ),
          title: 'Waktu Mulai',
          value: MyUtils.formatDateTime(auction.createdAt),
        ),
        AuctionPropRow(
          icon: Icon(
            Icons.schedule,
            color: Colors.red.shade800,
          ),
          title: 'Waktu Selesai',
          value: MyUtils.formatDateTime(auction.expiredAt),
        ),
        AuctionPropRow(
          icon: Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
          ),
          title: 'Status',
          value: statusText,
        ),
        const Divider(),
        AuctionPropRow(
          icon: Icon(
            Icons.store,
            color: Colors.blue.shade800,
          ),
          title: 'Lokasi',
          value: auction.store.name,
        ),
        AuctionPropRow(
          icon: Icon(
            Icons.person,
            color: Colors.blue.shade800,
          ),
          title: 'Nama Nelayan',
          value: auction.sellerName,
        ),
        AuctionPropRow(
          icon: Icon(
            Icons.set_meal,
            color: Colors.orange.shade800,
          ),
          title: 'Ikan',
          value: fishText,
        ),
        AuctionPropRow(
          icon: Icon(
            Icons.scale,
            color: Colors.brown.shade800,
          ),
          title: 'Berat total',
          value: '${MyUtils.formatNumber(totalQuantity)} Kg',
        ),
        AuctionPropRow(
          icon: Icon(
            Icons.sell,
            color: Colors.green.shade800,
          ),
          title: minPriceLabel,
          value: '${MyUtils.formatNumber(minPriceValue)} IDR',
        ),
        const Divider(),
        AuctionPropRow(
          icon: Icon(
            Icons.gavel,
            color: Colors.red.shade800,
          ),
          title: 'Penawaran',
          value: '',
        ),
        const SizedBox(height: 16),
        _buildBidSection(auction),
      ],
    );
  }

  Widget _buildBidSection(Auction auction) {
    bool oneFish = auction.fishSells.length == 1;
    double divider = oneFish ? auction.fishSells[0].quantity : 1;

    List<Widget> bidRows = auction.bids
        .asMap()
        .entries
        .map((e) => BidRow(
              name: e.value.user.fullName,
              value: e.value.value.toDouble(),
              oneFish: oneFish,
              divider: divider,
              type: e.key == 0 ? 2 : 1,
              dateTime: e.value.createdAt,
            ))
        .toList();

    return Column(
      children: [
        ...bidRows,
        BidRow(
          name: 'Harga Awal',
          value: auction.minBid.toDouble(),
          oneFish: oneFish,
          divider: divider,
          type: 0,
          dateTime: auction.createdAt,
        ),
      ],
    );
  }

  void Function()? _onPressedBid(
      BuildContext context, AuctionDetailViewModel viewModel) {
    if (!viewModel.formEnabled) {
      return null;
    }

    return () async {
      if (!viewModel.formKey.currentState!.validate()) return;

      MyUtils.showLoading(context);
      String? errorMessage = await viewModel.createBid();

      if (context.mounted) {
        Navigator.pop(context);

        if (errorMessage != null) {
          MyUtils.showErrorDialog(context, message: errorMessage);
          return;
        }

        viewModel.initialise();
      }
    };
  }
}
