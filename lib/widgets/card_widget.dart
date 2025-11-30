import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/models/card.dart' as card_model;

class CardWidget extends StatelessWidget {
  final Player player;
  final card_model.Card? card;
  final Function()? onTap;
  final double? cardWidth;
  final double? cardHeight;
  final bool? disableRotation;
  final bool? disableGestureDetector;

  const CardWidget({
    super.key,
    required this.player,
    this.card,
    this.onTap,
    this.cardWidth,
    this.cardHeight,
    this.disableRotation,
    this.disableGestureDetector,
  });

  @override
  Widget build(BuildContext context) {
    final card_model.Card playerCard = card ?? player.deck.peek();

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

    if (cardWidth != null && cardHeight != null) {
      final double adaptedWidth = player.hasVerticalPosition ? cardWidth! : cardHeight!;
      final double adaptedHeight = player.hasVerticalPosition ? cardHeight! : cardWidth!;
      cardWidget = SizedBox(width: adaptedWidth, height: adaptedHeight, child: cardWidget);
    }

    if (onTap != null && disableGestureDetector == null) {
      cardWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}