import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/utils/my_utils.dart';

class BidRow extends StatelessWidget {
  const BidRow({
    super.key,
    required this.name,
    required this.value,
    this.oneFish = false,
    this.divider = 1,
    required this.type,
    required this.dateTime,
  });

  final String name;
  final double value;
  final bool oneFish;
  final double divider;
  final int type;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/timeline.png';

    if (type == 0) {
      imagePath = 'assets/images/timeline_zero.png';
    } else if (type == 2) {
      imagePath = 'assets/images/timeline_top.png';
    }

    String valueText = '${MyUtils.formatNumber(value)} IDR';
    if (oneFish) {
      valueText = '${MyUtils.formatNumber(value / divider)} (${MyUtils.formatNumber(value)}) IDR';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            MyUtils.formatDateAgo(
              dateTime,
              withTime: true,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          child: Image.asset(imagePath, width: 24),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                valueText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(name),
            ],
          ),
        ),
      ],
    );
  }
}
