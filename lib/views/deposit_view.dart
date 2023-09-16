import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:perindo_bisnis_flutter/models/deposit.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';
import 'package:perindo_bisnis_flutter/viewmodels/deposit_view_model.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_button.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';

class DepositView extends StackedView<DepositViewModel> {
  const DepositView({super.key});

  @override
  Widget builder(
      BuildContext context, DepositViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Setor'),
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
                    Form(
                      key: viewModel.formKey,
                      child: MyTextFormField(
                        controller: viewModel.amountController,
                        labelText: 'Nominal Setor',
                        suffixText: 'IDR',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: (value) => MyUtils.noEmptyValidator(value),
                        onChanged: (value) => viewModel.calculateTotalAmount(),
                      ),
                    ),
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
              text: 'Setor',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.blue.shade50,
              onPressed: () => _onPressedDeposit(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DepositViewModel viewModelBuilder(BuildContext context) => DepositViewModel();

  void _onPressedDeposit(
      BuildContext context, DepositViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);

    try {
      Deposit? deposit = await viewModel.createDeposit();
      if (context.mounted) {
        Navigator.pop(context);
        _showDepositSuccessDialog(context, deposit!);
      }
    } catch (e) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(context, message: e.toString());
    }
  }

  Future _showDepositSuccessDialog(BuildContext context, Deposit deposit) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menunggu Pembayaran'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Lakukan pembayaran pada tautan berikut:'),
            InkWell(
              onTap: () async =>
                  await _launchUrl(context, deposit.paymentLink),
              child: Text(
                deposit.paymentLink,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue.shade800,
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Saya sudah melakukan pembayaran'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future _launchUrl(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: const CustomTabsOption(),
        safariVCOption: const SafariViewControllerOption(),
      );
    } catch (e) {
      MyUtils.showSnackbar(context, 'Browser tidak terpasang.');
    }
  }
}
