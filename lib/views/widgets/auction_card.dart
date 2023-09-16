import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/bid.dart';
import 'package:perindo_bisnis_flutter/models/fish_sell.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({
    super.key,
    required this.auction,
    this.withStore = true,
    this.onDetailPressed,
  });

  final Auction auction;
  final bool withStore;
  final Function()? onDetailPressed;

  @override
  Widget build(BuildContext context) {
    String fishText = '';

    for (var i = 0; i < auction.fishSells.length; i++) {
      FishSell fishSell = auction.fishSells[i];
      String fishName = fishSell.fish.name;
      String fishWeight = '(${MyUtils.formatNumber(fishSell.quantity)} Kg)';

      if (i >= auction.fishSells.length - 1) {
        fishText += '$fishName $fishWeight';
      } else {
        fishText += '$fishName $fishWeight, ';
      }
    }

    String lastBiddingText = '${MyUtils.formatNumber(auction.lastBid)} IDR';

    String statusText = 'Berlangsung';
    if (auction.status == 1) statusText = 'Proses pemenang';
    if (auction.status >= 2) statusText = 'Selesai';

    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(MyUtils.formatDateAgo(auction.createdAt)),
                Expanded(
                  child: Text(
                    statusText,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Icon(
                  Icons.set_meal,
                  color: Colors.orange.shade800,
                ),
                const SizedBox(width: 8),
                Text(fishText),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                withStore
                    ? Row(
                        children: [
                          Icon(
                            Icons.store,
                            color: Colors.blue.shade800,
                          ),
                          const SizedBox(width: 8),
                          Text(auction.store.name),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.blue.shade800,
                          ),
                          const SizedBox(width: 8),
                          Text(auction.sellerName),
                        ],
                      ),
                Row(
                  children: [
                    Icon(
                      Icons.sell,
                      color: Colors.green.shade800,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lastBiddingText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            TextButton(
              onPressed: onDetailPressed ?? () {},
              child: const Text('Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
