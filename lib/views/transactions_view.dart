import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/viewmodels/transactions_view_model.dart';
import 'package:perindo_bisnis_flutter/views/widgets/transaction_card.dart';
import 'package:stacked/stacked.dart';

class TransactionsView extends StackedView<TransactionsViewModel> {
  const TransactionsView({super.key});

  @override
  Widget builder(
      BuildContext context, TransactionsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Riwayat Transaksi'),
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.initialise,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildTransactionsSection(context, viewModel),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  TransactionsViewModel viewModelBuilder(BuildContext context) =>
      TransactionsViewModel();

  Widget _buildTransactionsSection(
      BuildContext context, TransactionsViewModel viewModel) {
    if (viewModel.trxBusy || viewModel.userBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.transactions.isEmpty) {
      return const Text('Belum ada transaksi');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: viewModel.transactions
          .map((trx) => TransactionCard(
                transaction: trx,
                currentUser: viewModel.seaseedUser,
              ))
          .toList(),
    );
  }
}
