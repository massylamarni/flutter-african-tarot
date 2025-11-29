import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final String cardImagePath;
  final int quarterTurns;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const CardContainer({
    super.key,
    required this.cardImagePath,
    this.quarterTurns = 0,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = RotatedBox(
      quarterTurns: quarterTurns,
      child: Image.asset(cardImagePath, fit: BoxFit.contain),
    );

    if (width != null || height != null) {
      card = SizedBox(width: width, height: height, child: card);
    }

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}