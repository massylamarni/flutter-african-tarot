import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';

class CardWidget extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;
  final double? cardWidth;
  final double? cardHeight;
  final bool? disableRotation;

  const CardWidget({
    super.key,
    required this.player,
    this.onTap,
    this.cardWidth,
    this.cardHeight,
    this.disableRotation,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Image.asset(
      player.deck.peek().assetPath, fit: BoxFit.contain
    );

    if (disableRotation == null) {
      card = RotatedBox(
        quarterTurns: player.mapPlayerPosition,
        child: card,
      );
    }

    if (cardWidth != null || cardHeight != null) {
      card = SizedBox(width: cardWidth, height: cardHeight, child: card);
    }

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}