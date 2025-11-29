import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tarot_africain/models/game.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/models/card.dart' as card;
import './card_pack_widget.dart';
import './spread_card_pack_widget.dart';
import './card_widget.dart';

const double cardAspectRatio = 250 / 481;

class BoardWidget extends StatefulWidget {
  final double appBarHeight;
  final double footerHeight;

  const BoardWidget({
    super.key,
    required this.appBarHeight,
    required this.footerHeight,
  });

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  Game game = Game([]);
  card.Card? selectedCard;
  Alignment selectedCardAlignment = Alignment.center;
  bool cardInCenter = false;

  @override
  void initState() {
    super.initState();
    game = Game([
      Player("Player 1", PlayerPosition.left),
      Player("Player 2", PlayerPosition.top),
      Player("Player 3", PlayerPosition.right),
      Player("Player 4", PlayerPosition.bottom),
    ]);

    game.startGame();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double boardSize = min(
      screenSize.width,
      screenSize.height - widget.appBarHeight - widget.footerHeight,
    );
    final double cardHeight = boardSize * 1 / 4;
    final double cardWidth = cardHeight * cardAspectRatio;
    final double margins = 0;
    final List<Player> players = game.players;

    Widget board = Center(
      child: SizedBox(
        width: boardSize,
        height: boardSize,
        child: Row(
          children: [
            Expanded(
              // Left
              flex: 1,
              child: SpreadCardPackWidget(
                player: players[0],
                height: cardWidth,
                width: cardHeight,
                onTap: () {
                  setState(() {
                    selectedCard = players[0].deck.peek();
                  });
                },
              ),
            ),
            Expanded(
              // Middle
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    // Top
                    flex: 1,
                    child: SpreadCardPackWidget(
                      player: players[1],
                      height: cardHeight,
                      width: cardWidth,
                      onTap: () {
                        setState(() {
                          selectedCard = players[1].deck.peek();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    // Center
                    flex: 2,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(margins),
                          color: Colors.green.shade300,
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          top: cardInCenter ? 50 : 0,
                          bottom: cardInCenter ? null : 0,
                          left: cardInCenter ? 0 : null,
                          right: cardInCenter ? 0 : null,
                          child: CardWidget(
                            player: players[1],
                            width: cardWidth,
                            height: cardHeight,
                            onTap: () {
                              setState(() {
                                cardInCenter = !cardInCenter;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // Bottom
                    flex: 1,
                    child: SpreadCardPackWidget(
                      player: players[3],
                      height: cardHeight,
                      width: cardWidth,
                      onTap: () {
                        setState(() {
                          selectedCard = players[3].deck.peek();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // Right
              flex: 1,
              child: SpreadCardPackWidget(
                player: players[2],
                height: cardWidth,
                width: cardHeight,
                onTap: () {
                  setState(() {
                    selectedCard = players[2].deck.peek();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );

    return board;
  }
}
