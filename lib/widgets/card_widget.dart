import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';

class CardWidget extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool? disableRotation;

  const CardWidget({
    super.key,
    required this.player,
    this.onTap,
    this.width,
    this.height,
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

    if (width != null || height != null) {
      card = SizedBox(width: width, height: height, child: card);
    }

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}