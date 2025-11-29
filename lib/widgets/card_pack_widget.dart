import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/widgets/card_widget.dart';

class CardPackWidget extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double offset;

  const CardPackWidget({
    super.key,
    required this.player,
    this.onTap,
    this.width,
    this.height,
    this.offset = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardPack = Stack(
        children: [
          for (int i = 0; i < player.deck.cards.length; i++)
            Positioned(
              top: i * offset,
              left: i * offset,
              child: CardWidget(
                player: player,
                width: width,
                height: height,
                onTap: i == player.deck.cards.length - 1 ? onTap : null,
              ),
            )
        ],
    );

    if (width != null || height != null) {
      cardPack = SizedBox(width: width, height: height, child: cardPack);
    }

    return cardPack;
  }
}
