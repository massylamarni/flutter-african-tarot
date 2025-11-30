import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tarot_africain/models/card_pack.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/widgets/card_widget.dart';

const MAX_CARD_STACK_DISPLAY = 5;

class CardPackWidget extends StatelessWidget {
  final Player player;
  final CardPack? cardPack;
  final VoidCallback? onTap;
  final double cardWidth;
  final double cardHeight;
  final double offset;

  const CardPackWidget({
    super.key,
    required this.player,
    this.cardPack,
    this.onTap,
    required this.cardWidth,
    required this.cardHeight,
    this.offset = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final CardPack playerCardPack = cardPack ?? player.deck;
    final int cardCount = playerCardPack.cards.length;
    final double adaptedWidth = player.hasVerticalPosition ? cardHeight : cardHeight;
    final double adaptedHeight = player.hasVerticalPosition ? cardHeight : cardHeight;
    final double maxOffsetSize = (cardCount - 1) * offset;
    final int offsetCount = min(MAX_CARD_STACK_DISPLAY, cardCount);

    Widget cardPackWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < cardCount; i++)
            Positioned(
              top: i < offsetCount ? i * offset : offsetCount * offset,
              left: i < offsetCount ? i * offset : offsetCount * offset,
              child: CardWidget(
                player: player,
                card: playerCardPack.peek(),
                cardWidth: adaptedWidth,
                cardHeight: adaptedHeight,
                onTap: i == cardCount - 1 ? onTap : null,
              ),
            )
        ],
    );

    cardPackWidget = Center(
      child: SizedBox(
        width: adaptedWidth + maxOffsetSize,
        height: adaptedHeight + maxOffsetSize,
        child: cardPackWidget
      ),
    );

    return cardPackWidget;
  }
}
