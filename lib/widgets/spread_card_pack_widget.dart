import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/widgets/card_widget.dart';

const int hotFix0 = 80; // Magic number that fixes card pack position

class SpreadCardPackWidget extends StatelessWidget {
  final Player player;
  final bool showOpponentCards;
  final Function(int)? onTap;
  final double cardWidth;
  final double cardHeight;
  final double radius;
  final double angleDelta; // spacing between cards in degrees

  const SpreadCardPackWidget({
    super.key,
    required this.player,
    required this.showOpponentCards,
    required this.cardWidth,
    required this.cardHeight,
    this.onTap,
    this.radius = 80,
    this.angleDelta = 12,
  });

  @override
  Widget build(BuildContext context) {
    final int cardCount = player.deck.cards.length;
    final double adaptedWidth = (player.hasVerticalPosition ? cardWidth : cardHeight);
    final double adaptedHeight = (player.hasVerticalPosition ? cardHeight : cardHeight);
  
    double getArcAngle(int index) {
      final double startAngle = -1 * (cardCount - 1) * angleDelta / 2; // Middle card angle is 0°, others spread around it
      return (startAngle + index * angleDelta) * pi / 180; // Convert to radian
    }

    double getRotationAngle(int index) {
      final arc = getArcAngle(index);

      switch (player.position) {
        case PlayerPosition.bottom: return arc;
        case PlayerPosition.top: return arc + pi;
        case PlayerPosition.right: return arc - pi/2;
        case PlayerPosition.left: return arc + pi/2;
      }
    }

    Offset getShiftedPosition(int index) {
      final angle = getArcAngle(index);
      final dx = radius * sin(angle);
      final dy = -radius * cos(angle) + hotFix0;

      switch (player.position) {
        case PlayerPosition.left: return Offset(-dy, dx);
        case PlayerPosition.top: return Offset(-dx, -dy);
        case PlayerPosition.right: return Offset(dy, -dx);
        case PlayerPosition.bottom: return Offset(dx, dy);
      }
    }

    Widget spreadCardPackWidget = SizedBox(
      width: adaptedWidth,
      height: adaptedHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < cardCount; i++)
            Transform.translate(
              offset: getShiftedPosition(i),
              child: GestureDetector(
                onTap: () => onTap!(i),
                child: Transform.rotate(
                  angle: getRotationAngle(i),
                  child: CardWidget(
                    player: player,
                    card: player.deck.cards[i],
                    cardWidth: adaptedWidth,
                    cardHeight: adaptedHeight,
                    hideCard: !showOpponentCards,
                    disableRotation: true,
                    disableGestureDetector: true,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return spreadCardPackWidget;
  }
}
