import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tarot_africain/models/game.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/models/card.dart' as card_model;
import 'package:tarot_africain/models/round.dart';
import 'package:tarot_africain/utils/game_controller.dart';
import 'package:tarot_africain/widgets/player_widget.dart';
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
  GameController controller = GameController(Game({}));
  Player mainPlayer = Player(0, "Main player", PlayerPosition.bottom);
  Map<int, card_model.Card> selectedCards = {};
  Alignment selectedCardAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    controller.game = Game({
      0: mainPlayer,
      1: Player(1, "Player 1", PlayerPosition.left),
      2: Player(2, "Player 2", PlayerPosition.top),
      3: Player(3, "Player 3", PlayerPosition.right),
    });

    controller.addListener(_onPhaseChanged);
    controller.startInitGameSequence();
  }

  void _onPhaseChanged() {
    setState(() {
      switch(controller.currentPhase) {
        case GamePhase.distributePointCardPack:
          controller.startDistributePointCardPackSequence();
          break;
        case GamePhase.placeBids:
          null;
          break;
        case GamePhase.placeCards:
          null;
          break;
        case GamePhase.endOfRound:
          null;
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    controller.removeListener(_onPhaseChanged);
    super.dispose();
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
    final Map<int, Player> players = controller.game.players;
    Player voidPlayer = Player.voidPlayer();
    Player heartsPlayer = Player.heartsPlayer();
    Player spadesPlayer = Player.spadesPlayer();
    Player clubsPlayer = Player.clubsPlayer();
    Player diamondsPlayer = Player.diamondsPlayer();
    voidPlayer.deck = controller.game.initialCardPack;
    heartsPlayer.deck = controller.game.heartsCardpack;
    spadesPlayer.deck = controller.game.spadesCardpack;
    clubsPlayer.deck = controller.game.clubsCardpack;
    diamondsPlayer.deck = controller.game.diamondsCardpack;

    if (controller.currentPhase == GamePhase.distributePointCardPack) {
      // Decide who is the dealder TODO choose who is the dealer, lasts 5 rounds then gives role to left player.
      controller.game.dealerIndex = 3;
      
      // Init round
      controller.game.round = Round(players);
      controller.game.round.centerCards = selectedCards;
      controller.game.initialCardPack.shuffle();

      // Distribute cards to players
      controller.game.round.distributeCards(controller.game.initialCardPack, controller.game.round.distributedCardCount);
    } else if (controller.currentPhase == GamePhase.placeBids) {
      players[0]?.pointDeck = diamondsPlayer.deck;
      players[1]?.pointDeck = clubsPlayer.deck;
      players[2]?.pointDeck = heartsPlayer.deck;
      players[3]?.pointDeck = spadesPlayer.deck;
    }

    Widget sharedPlayerArea(int index) {
      Widget widget;
      if (controller.currentPhase == GamePhase.initGame) {
        return Container();
      } else if (controller.currentPhase == GamePhase.distributePointCardPack) {
        return Container();
      } else {
        widget = SpreadCardPackWidget(
          player: players[index]!,
          cardHeight: cardHeight,
          cardWidth: cardWidth,
          onTap: () {
            setState(() {
              selectedCards[index] = players[index]!.deck.peek();
            });
          },
        );
      }
      
      return widget;
    }

    Widget sharedPlayerSlot(int index) {
      Widget widget;
      if (controller.currentPhase == GamePhase.initGame) {
        return Container();
      } else if (controller.currentPhase == GamePhase.distributePointCardPack) {
        return Container();
      } else if (controller.currentPhase == GamePhase.placeBids) {
        widget = CardPackWidget(
          player: players[index]!,
          cardPack: players[index]?.pointDeck,
          cardHeight: cardHeight,
          cardWidth: cardWidth,
        );

        return widget;
      } else {
        widget = CardPackWidget(
          player: players[index]!,
          cardHeight: cardHeight,
          cardWidth: cardWidth,
        );

        return widget;
      }
    }

    Widget leftPlayerArea() {return sharedPlayerArea(1);}
    Widget topPlayerArea() {return sharedPlayerArea(2);}
    Widget rightPlayerArea() {return sharedPlayerArea(3);}
    Widget bottomPlayerArea() {return sharedPlayerArea(0);}

    Widget leftPlayerSlot() {return sharedPlayerSlot(1);}
    Widget topPlayerSlot() {return sharedPlayerSlot(2);}
    Widget rightPlayerSlot() {return sharedPlayerSlot(3);}
    Widget bottomPlayerSlot() {return sharedPlayerSlot(0);}

    Widget boardCenter() {
      Widget widget;
      if (controller.currentPhase == GamePhase.initGame) {
        widget = AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: 50,
          left: 0,
          right: 0,
          child: CardPackWidget(
            player: voidPlayer,
            cardWidth: cardWidth,
            cardHeight: cardHeight
          )
        );
      } else if (controller.currentPhase == GamePhase.distributePointCardPack) {
        double spacing = -30;
        List<List<double?>> positions = [
          [spacing, spacing, null, null],
          [null, spacing, spacing, null],
          [spacing, null, null, spacing],
          [null, null, spacing, spacing],
        ];
        List<Player> intermediatePlayers = [
          heartsPlayer,
          spadesPlayer,
          clubsPlayer,
          diamondsPlayer
        ];
        widget = Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < players.length; i++) AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: positions[i][0],
              top: positions[i][1],
              right: positions[i][2],
              bottom: positions[i][3],
              child: CardPackWidget(
                player: intermediatePlayers[i],
                cardWidth: cardWidth,
                cardHeight: cardHeight
              )
            ),
          ],
        );
      } else if (controller.currentPhase == GamePhase.placeBids) {
        List<List<double?>> positions = [
          [0, null, 0, 50],
          [50, 0, null, 0],
          [0, 50, 0, null],
          [null, 0, 50, 0],
        ];
        widget = Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < players.length; i++) AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: selectedCards[i] != null ? positions[i][0] : null,
              top: selectedCards[i] != null ? positions[i][1] : null, 
              right: selectedCards[i] != null ? positions[i][2] : null,
              bottom: selectedCards[i] != null ? positions[i][3] : null,
              child: selectedCards[i] != null ? CardWidget(
                player: players[i]!,
                card: selectedCards[i],
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ) : Container(),
            )
          ],
        );
        return widget;
      } else {
        List<List<double?>> positions = [
          [0, null, 0, 50],
          [50, 0, null, 0],
          [0, 50, 0, null],
          [null, 0, 50, 0],
        ];
        widget = Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < players.length; i++) AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: selectedCards[i] != null ? positions[i][0] : null,
              top: selectedCards[i] != null ? positions[i][1] : null, 
              right: selectedCards[i] != null ? positions[i][2] : null,
              bottom: selectedCards[i] != null ? positions[i][3] : null,
              child: selectedCards[i] != null ? CardWidget(
                player: players[i]!,
                card: selectedCards[i],
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ) : Container(),
            )
          ],
        );
      }
      return widget;
    }

    Widget boardWidget = Center(
      child: SizedBox(
        width: boardSize,
        height: boardSize,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(flex: 1, child: topPlayerSlot()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: topPlayerArea()
                    ),
                  ),
                  Expanded(flex: 1, child: rightPlayerSlot()),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(flex: 1, child: leftPlayerArea()),
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(margins),
                          color: Colors.green.shade300,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: PlayerWidget(player: players[2]!)),
                                  ],
                                )
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(child: PlayerWidget(player: players[1]!)),
                                    Expanded(child: PlayerWidget(player: players[3]!)),
                                  ],
                                )
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(child: PlayerWidget(player: players[0]!)),
                                  ],
                                )
                              ),
                            ],
                          ),
                        ),
                        boardCenter(),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: rightPlayerArea()),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(flex: 1, child: leftPlayerSlot()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: bottomPlayerArea()
                    ),
                  ),
                  Expanded(flex: 1, child: bottomPlayerSlot()),
                ],
              ),
            ),
          ],
        ),
      ),
    );


    return boardWidget;
  }
}
