import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/models/bank.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';
import 'package:perindo_bisnis_flutter/viewmodels/withdrawal_view_model.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_button.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_dropdown.dart';
import 'package:perindo_bisnis_flutter/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';

class WithdrawalView extends StackedView<WithdrawalViewModel> {
  const WithdrawalView({super.key});

  @override
  Widget builder(
      BuildContext context, WithdrawalViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Tarik'),
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
                text: 'Tarik',
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
                onPressed: () => _onPressedWithdraw(context, viewModel),
              ),
            ],
          ),
        ));
  }

  @override
  WithdrawalViewModel viewModelBuilder(BuildContext context) =>
      WithdrawalViewModel();

  Widget _buildForm(BuildContext context, WithdrawalViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          MyTextFormField(
            controller: viewModel.amountController,
            labelText: 'Nominal Tarik',
            suffixText: 'IDR',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) => MyUtils.noEmptyValidator(value),
            onChanged: (value) => viewModel.calculateTotalAmount(),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.accountNoController,
            labelText: 'Nomor Rekening',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyDropdown<Bank>(
            items: const [],
            asyncItems: (_) => viewModel.getBanks(),
            itemAsString: (bank) => bank.name,
            compareFn: (a, b) => a.id == b.id,
            labelText: 'Nama Bank',
            selectedItem: viewModel.bank,
            onChanged: (bank) {
              if (bank is Bank) {
                viewModel.bank = bank;
              }
            },
            validator: (value) => MyUtils.mustSelectValidator(value),
          ),
        ],
      ),
    );
  }

  void _onPressedWithdraw(
      BuildContext context, WithdrawalViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);

    try {
      await viewModel.createWithdrawal();
      if (context.mounted) {
        Navigator.pop(context);
        MyUtils.showSuccessDialog(
          context,
          message: 'Penarikan dalam proses verifikasi.',
          doublePop: true,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(context, message: e.toString());
    }
  }
}
