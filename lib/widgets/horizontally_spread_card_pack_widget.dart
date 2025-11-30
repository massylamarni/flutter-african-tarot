import 'package:flutter/material.dart';
import 'package:tarot_africain/models/card_pack.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/widgets/card_widget.dart';

class HorizontallySpreadCardPackWidget extends StatelessWidget {
  final Player player;
  final CardPack? cardPack;
  final Function(int)? onTap;
  final double cardWidth;
  final double cardHeight;
  final double offset;

  const HorizontallySpreadCardPackWidget({
    super.key,
    required this.player,
    this.cardPack,
    this.onTap,
    required this.cardWidth,
    required this.cardHeight,
    this.offset = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final CardPack playerCardPack = cardPack ?? player.deck;
    final int cardCount = playerCardPack.cards.length;
    final double adaptedWidth = player.hasVerticalPosition ? cardWidth : cardHeight;
    final double adaptedHeight = player.hasVerticalPosition ? cardHeight : cardWidth;
    final double maxOffsetSize = (cardCount - 1) * offset;

    Widget cardPackWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < cardCount; i++)
            Positioned(
              left: i * offset,
              child: CardWidget(
                player: player,
                card: playerCardPack.cards[i],
                cardWidth: adaptedWidth,
                cardHeight: adaptedHeight,
                onTap: () => onTap!(i),
              ),
            )
        ],
    );

    cardPackWidget = Center(
      child: SizedBox(
        width: adaptedWidth + maxOffsetSize,
        height: adaptedHeight,
        child: cardPackWidget
      ),
    );

    return cardPackWidget;
  }
}
