import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/widgets/card_widget.dart';

class CardPackWidget extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double offset;

  const CardPackWidget({
    super.key,
    required this.player,
    this.onTap,
    required this.width,
    required this.height,
    this.offset = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final int cardCount = player.deck.cards.length;
    final double adaptedWidth = player.hasVerticalPosition ? height : width;
    final double adaptedHeight = player.hasVerticalPosition ? height : width;
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
                width: adaptedWidth,
                height: adaptedHeight,
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
