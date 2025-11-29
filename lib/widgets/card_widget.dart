import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/models/card.dart' as cardModel;

class CardWidget extends StatelessWidget {
  final Player player;
  final cardModel.Card? card;
  final VoidCallback? onTap;
  final double? cardWidth;
  final double? cardHeight;
  final bool? disableRotation;

  const CardWidget({
    super.key,
    required this.player,
    this.card,
    this.onTap,
    this.cardWidth,
    this.cardHeight,
    this.disableRotation,
  });

  @override
  Widget build(BuildContext context) {
    final cardModel.Card playerCard = card ?? player.deck.peek();

    Widget cardWidget = Image.asset(
      playerCard.assetPath,
      fit: BoxFit.contain
    );

    if (disableRotation == null) {
      cardWidget = RotatedBox(
        quarterTurns: player.mapPlayerPosition,
        child: cardWidget,
      );
    }

    if (cardWidth != null || cardHeight != null) {
      cardWidget = SizedBox(width: cardWidth, height: cardHeight, child: cardWidget);
    }

    if (onTap != null) {
      cardWidget = GestureDetector(onTap: onTap, child: cardWidget);
    }

    return cardWidget;
  }
}