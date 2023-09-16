import 'package:flutter/material.dart';

class AuctionPropRow extends StatelessWidget {
  const AuctionPropRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final Icon icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
