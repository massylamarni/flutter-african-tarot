import 'package:flutter/material.dart';
import 'package:tarot_africain/models/player.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;

  const PlayerWidget({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {

    Widget cardWidget = RotatedBox(
      quarterTurns: player.mapPlayerPosition,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("${player.name} - (${player.tricksWon.toString()}/${player.tricksBid.toString()})"),
        ],
      )
    );

    return cardWidget;
  }
}