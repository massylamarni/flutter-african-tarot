import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/widgets/card_widget.dart';

class CardPackWidget extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;
  final double cardWidth;
  final double cardHeight;
  final double offset;

  const CardPackWidget({
    super.key,
    required this.player,
    this.onTap,
    required this.cardWidth,
    required this.cardHeight,
    this.offset = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final int cardCount = player.deck.cards.length;
    final double adaptedWidth = player.hasVerticalPosition ? cardHeight : cardHeight;
    final double adaptedHeight = player.hasVerticalPosition ? cardHeight : cardHeight;
    final double maxOffsetSize = (cardCount - 1) * offset;

    Widget cardPack = Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < cardCount; i++)
            Positioned(
              top: i * offset,
              left: i * offset,
              child: CardWidget(
                player: player,
                cardWidth: adaptedWidth,
                cardHeight: adaptedHeight,
                onTap: i == cardCount - 1 ? onTap : null,
              ),
            )
        ],
    );

    cardPack = Center(
      child: SizedBox(
        width: adaptedWidth + maxOffsetSize,
        height: adaptedHeight + maxOffsetSize,
        child: cardPack
      ),
    );

    return cardPack;
  }
}
