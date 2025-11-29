import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tarot_africain/models/game.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/models/card.dart' as cardModel;
import 'package:tarot_africain/models/round.dart';
import 'package:tarot_africain/utils/game_controller.dart';
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
  GameController controller = GameController(Game([]));
  Player mainPlayer = Player("Main player", PlayerPosition.bottom);
  cardModel.Card? selectedCard;
  Alignment selectedCardAlignment = Alignment.center;
  bool cardInCenter = false;

  @override
  void initState() {
    super.initState();
    controller.game = Game([
      Player("Player 1", PlayerPosition.left),
      Player("Player 2", PlayerPosition.top),
      Player("Player 3", PlayerPosition.right),
      mainPlayer,
    ]);

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
    final List<Player> players = controller.game.players;
    Player voidPlayer = Player("VOID_PLAYER", PlayerPosition.bottom);
    Player heartsPlayer = Player("HEARTS_PLAYER", PlayerPosition.bottom);
    Player spadesPlayer = Player("SPADES_PLAYER", PlayerPosition.bottom);
    Player clubsPlayer = Player("CLUBS_PLAYER", PlayerPosition.bottom);
    Player diamondsPlayer = Player("DIAMONS_PLAYER", PlayerPosition.bottom);
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
      controller.game.initialCardPack.shuffle();

      // Distribute cards to players
      controller.game.round.distributeCards(controller.game.initialCardPack, controller.game.round.distributedCardCount);
    } else if (controller.currentPhase == GamePhase.placeBids) {
      players[0].pointDeck = clubsPlayer.deck;
      players[1].pointDeck = heartsPlayer.deck;
      players[2].pointDeck = spadesPlayer.deck;
      mainPlayer.pointDeck = diamondsPlayer.deck;
    }

    Widget _sharedPlayerArea(int index) {
      Widget widget;
      if (controller.currentPhase == GamePhase.initGame) {
        return Container();
      } else if (controller.currentPhase == GamePhase.distributePointCardPack) {
        return Container();
      } else {
        widget = SpreadCardPackWidget(
          player: players[index],
          cardHeight: cardHeight,
          cardWidth: cardWidth,
          onTap: () {
            setState(() {
              selectedCard = players[index].deck.peek();
            });
          },
        );
      }
      
      return widget;
    }

    Widget _sharedPlayerSlot(int index) {
      Widget widget;
      if (controller.currentPhase == GamePhase.initGame) {
        return Container();
      } else if (controller.currentPhase == GamePhase.distributePointCardPack) {
        return Container();
      } else if (controller.currentPhase == GamePhase.placeBids) {
        widget = CardPackWidget(
          player: players[index],
          cardPack: players[index].pointDeck,
          cardHeight: cardHeight,
          cardWidth: cardWidth,
          onTap: () {
            setState(() {
              selectedCard = players[index].pointDeck.peek();
            });
          },
        );

        return widget;
      } else {
        widget = CardPackWidget(
          player: players[index],
          cardHeight: cardHeight,
          cardWidth: cardWidth,
          onTap: () {
            setState(() {
              selectedCard = players[index].deck.peek();
            });
          },
        );

        return widget;
      }
    }

    Widget _leftPlayerArea() {      
      return _sharedPlayerArea(0);
    }

    Widget _topPlayerArea() {
      return _sharedPlayerArea(1);
    }

    Widget _rightPlayerArea() {
      return _sharedPlayerArea(2);
    }

    Widget _bottomPlayerArea() {
      return _sharedPlayerArea(3);
    }

    Widget _leftPlayerSlot() {
      return _sharedPlayerSlot(0);
    }

    Widget _topPlayerSlot() {
      return _sharedPlayerSlot(1);
    }

    Widget _rightPlayerSlot() {
      return _sharedPlayerSlot(2);      
    }

    Widget _bottomPlayerSlot() {
      return _sharedPlayerSlot(3);      
    }

    Widget _boardCenter() {
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
        widget = Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: spacing,
              left: spacing,
              child: CardPackWidget(
                player: heartsPlayer,
                cardWidth: cardWidth,
                cardHeight: cardHeight
              )
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: spacing,
              right: spacing,
              child: CardPackWidget(
                player: spadesPlayer,
                cardWidth: cardWidth,
                cardHeight: cardHeight
              )
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              bottom: spacing,
              left: spacing,
              child: CardPackWidget(
                player: clubsPlayer,
                cardWidth: cardWidth,
                cardHeight: cardHeight
              )
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              bottom: spacing,
              right: spacing,
              child: CardPackWidget(
                player: diamondsPlayer,
                cardWidth: cardWidth,
                cardHeight: cardHeight
              )
            )
          ],
        );
      } else if (controller.currentPhase == GamePhase.placeBids) {
        widget = AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: cardInCenter ? 50 : 0,
          bottom: cardInCenter ? null : 0,
          left: cardInCenter ? 0 : null,
          right: cardInCenter ? 0 : null,
          child: CardWidget(
            player: players[1],
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            onTap: () {
              setState(() {
                cardInCenter = !cardInCenter;
              });
            },
          ),
        );
        return widget;
      } else {
        widget = AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: cardInCenter ? 50 : 0,
          bottom: cardInCenter ? null : 0,
          left: cardInCenter ? 0 : null,
          right: cardInCenter ? 0 : null,
          child: CardWidget(
            player: players[1],
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            onTap: () {
              setState(() {
                cardInCenter = !cardInCenter;
              });
            },
          ),
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
                  Expanded(flex: 1, child: _topPlayerSlot()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: _topPlayerArea()
                    ),
                  ),
                  Expanded(flex: 1, child: _rightPlayerSlot()),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(flex: 1, child: _leftPlayerArea()),
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(margins),
                          color: Colors.green.shade300,
                        ),
                        _boardCenter(),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: _rightPlayerArea()),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(flex: 1, child: _leftPlayerSlot()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: _bottomPlayerArea()
                    ),
                  ),
                  Expanded(flex: 1, child: _bottomPlayerSlot()),
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
