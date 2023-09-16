import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/models/seaseed_user.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';
import 'package:perindo_bisnis_flutter/viewmodels/transfer_view_model.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_button.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_dropdown.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';

class TransferView extends StackedView<TransferViewModel> {
  const TransferView({super.key});

  @override
  Widget builder(
      BuildContext context, TransferViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kirim'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildForm(context, viewModel),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Biaya admin'),
                        Text(viewModel.dataReady
                            ? '${MyUtils.formatNumber(viewModel.data)} IDR'
                            : '0 IDR'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          viewModel.dataReady
                              ? '${MyUtils.formatNumber(viewModel.totalAmount)} IDR'
                              : '0 IDR',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MyButton(
              text: 'Kirim',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.blue.shade50,
              onPressed: () => _onPressedTransfer(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  TransferViewModel viewModelBuilder(BuildContext context) =>
      TransferViewModel();

  Widget _buildForm(BuildContext context, TransferViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          MyDropdown<SeaseedUser>(
            items: const [],
            asyncItems: (_) => viewModel.getOtherSeaseedUsers(),
            itemAsString: (user) => user.fullName,
            compareFn: (a, b) => a.id == b.id,
            labelText: 'Tujuan Kirim',
            selectedItem: viewModel.receiverUser,
            onChanged: (user) {
              if (user is SeaseedUser) {
                viewModel.receiverUser = user;
              }
            },
            validator: (value) => MyUtils.mustSelectValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.amountController,
            labelText: 'Nominal Kirim',
            suffixText: 'IDR',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: (value) => MyUtils.noEmptyValidator(value),
            onChanged: (value) => viewModel.calculateTotalAmount(),
          ),
        ],
      ),
    );
  }

  void _onPressedTransfer(
      BuildContext context, TransferViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);

    try {
      await viewModel.createTransfer();
      if (context.mounted) {
        Navigator.pop(context);
        MyUtils.showSuccessDialog(
          context,
          message: 'Berhasil melakukan pengiriman.',
          doublePop: true,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(context, message: e.toString());
    }
  }
}
