import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/models/bni_account.dart';
import 'package:perindo_bisnis_flutter/models/bni_transfer.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';

class BniTransferCard extends StatelessWidget {
  const BniTransferCard({
    super.key,
    required this.transfer,
    required this.currentAccount,
  });

  final BniTransfer transfer;
  final BniAccount currentAccount;

  @override
  Widget build(BuildContext context) {
    String typeText = '';
    String signedAmount = '';
    String? transferDescription;

    if (transfer.fromAccount.id == currentAccount.id) {
      signedAmount = MyUtils.formatNumber(transfer.amount * -1);
      transferDescription = 'Ke ${transfer.toAccount.name}';
    } else {
      signedAmount = '+${MyUtils.formatNumber(transfer.amount)}';
      transferDescription = 'Dari ${transfer.fromAccount.name}';
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(MyUtils.formatDateAgo(transfer.createdAt)),
                Expanded(
                  child: Text(
                    typeText,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const Divider(),
            transfer.remark.isEmpty
                ? const SizedBox.shrink()
                : Text(transfer.remark),
            Text(transferDescription),
            Text(
              '$signedAmount IDR',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}