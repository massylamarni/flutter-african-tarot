import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tarot_africain/models/game.dart';
import 'package:tarot_africain/models/player.dart';
import 'package:tarot_africain/models/card.dart' as card_model;
import 'package:tarot_africain/models/round.dart';
import 'package:tarot_africain/utils/game_controller.dart';
import 'package:tarot_africain/widgets/excuse_selector_widget.dart';
import 'package:tarot_africain/widgets/horizontally_spread_card_pack_widget.dart';
import 'package:tarot_africain/widgets/player_widget.dart';
import 'package:tarot_africain/widgets/trick_selector_widget.dart';
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
  Player mainPlayer = Player(0, "You", PlayerPosition.bottom);
  Map<int, card_model.Card> selectedCards = {};
  Alignment selectedCardAlignment = Alignment.center;
  bool showOpponentCards = false;
  bool showMainPlayerCards = true;

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
      switch (controller.currentPhase) {
        case GamePhase.initGame:
          controller.startInitGameSequence();
          break;
        case GamePhase.distributePointCardPack:
          controller.startDistributePointCardPackSequence();
          break;
        case GamePhase.placeBids:
          break;
        case GamePhase.placeCards:
          break;
        case GamePhase.getTrickWinner:
          break;
        case GamePhase.endOfRound:
          break;
        case GamePhase.endOfGame:
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
    final double margins = 5;
    final double paddings = 10;
    Map<int, Player> players = controller.game.players;
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

    Widget Function(int) sharedPlayerArea = (i) => Container();
    Widget Function(int) sharedPlayerSlot = (i) => Container();
    Widget Function() boardCenter = () => Container();

    /* INIT GAME */
    if (controller.currentPhase == GamePhase.initGame) {
      controller.game = Game({
        0: Player(0, "You", PlayerPosition.bottom),
        1: Player(1, "Player 1", PlayerPosition.left),
        2: Player(2, "Player 2", PlayerPosition.top),
        3: Player(3, "Player 3", PlayerPosition.right),
      });

      players = controller.game.players;

      voidPlayer = Player.voidPlayer();
      heartsPlayer = Player.heartsPlayer();
      spadesPlayer = Player.spadesPlayer();
      clubsPlayer = Player.clubsPlayer();
      diamondsPlayer = Player.diamondsPlayer();
      voidPlayer.deck = controller.game.initialCardPack;
      heartsPlayer.deck = controller.game.heartsCardpack;
      spadesPlayer.deck = controller.game.spadesCardpack;
      clubsPlayer.deck = controller.game.clubsCardpack;
      diamondsPlayer.deck = controller.game.diamondsCardpack;

      // Decide who is the dealder TODO choose who is the dealer, lasts 5 rounds then gives role to left player.
      controller.game.dealerId = players[0]!.id;

      // Init round
      controller.game.round = Round(players);
      controller.game.round.centerCards = selectedCards;

      // Widgets
      boardCenter = () => AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: CardPackWidget(
          player: voidPlayer,
          cardWidth: cardWidth,
          cardHeight: cardHeight,
        ),
      );
    }
    /* DISTRIBUTE POINT_CARD_PACK */
    else if (controller.currentPhase == GamePhase.distributePointCardPack) {
      controller.game.initialCardPack.shuffle();

      // Distribute cards to players
      controller.game.round.distributeCards(
        controller.game.initialCardPack,
        controller.game.round.distributedCardCount,
      );

      // Widgets
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
        diamondsPlayer,
      ];
      boardCenter = () => Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < players.length; i++)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: positions[i][0],
              top: positions[i][1],
              right: positions[i][2],
              bottom: positions[i][3],
              child: CardPackWidget(
                player: intermediatePlayers[i],
                cardPack: players[i]!.pointDeck,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
            ),
        ],
      );
    }
    /* PLACE BIDS */
    else if (controller.currentPhase == GamePhase.placeBids) {
      players[0]?.pointDeck = diamondsPlayer.deck;
      players[1]?.pointDeck = clubsPlayer.deck;
      players[2]?.pointDeck = heartsPlayer.deck;
      players[3]?.pointDeck = spadesPlayer.deck;

      // Widgets
      sharedPlayerArea = (i) => SpreadCardPackWidget(
        player: players[i]!,
        showOpponentCards: i != 0 ? showOpponentCards : showMainPlayerCards,
        cardHeight: cardHeight,
        cardWidth: cardWidth,
        onTap: (cardIndex) {},
      );

      sharedPlayerSlot = (i) => CardPackWidget(
        player: players[i]!,
        cardPack: players[i]?.pointDeck,
        cardHeight: cardHeight,
        cardWidth: cardWidth,
      );

      boardCenter = () => Center(
        child: TrickSelectorWidget(
          value: players[0]!.tricksBid,
          onChanged: (v) => setState(() {
            players[0]!.tricksBid = v;
            controller.game.round.bid(controller.game.dealerId, players[0]!.id);
            controller.nextPhase(false);
          }),
        ),
      );
    }
    /* PLACE CARDS */
    else if (controller.currentPhase == GamePhase.placeCards) {
      voidPlayer.deck.pickAll(controller.game.round.centerCards);

      Future<int?> showExcuseSelectorPopup(
        BuildContext context,
        int currentValue,
      ) {
        return showDialog<int>(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) {
            return Dialog(
              insetPadding: EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: SizedBox(
                  width: 250,
                  height: 300,
                  child: ExcuseSelectorWidget(
                    value: currentValue,
                    onChanged: (v) {
                      Navigator.of(dialogContext).pop(v);
                    },
                  ),
                ),
              ),
            );
          },
        );
      }

      // Widgets
      sharedPlayerArea = (i) => i != 0
          ? SpreadCardPackWidget(
              player: players[i]!,
              showOpponentCards: showOpponentCards,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {},
            )
          : HorizontallySpreadCardPackWidget(
              player: players[i]!,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {
                if (players[i]!.deck.cards[cardIndex].cardType ==
                    card_model.CardType.excuse) {
                  showExcuseSelectorPopup(context, 1).then((selectedValue) {
                    if (selectedValue == null) return;

                    setState(() {
                      players[i]!.deck.cards[cardIndex].cardValue =
                          selectedValue;
                      selectedCards[i] = players[i]!.playCard(
                        players[i]!.deck.cards[cardIndex],
                      );
                      controller.game.round.placeCards(players[0]!.id);
                      controller.nextPhase(false);
                    });
                  });
                } else {
                  setState(() {
                    selectedCards[i] = players[i]!.playCard(
                      players[i]!.deck.cards[cardIndex],
                    );
                    controller.game.round.placeCards(players[0]!.id);
                    controller.nextPhase(false);
                  });
                }
              },
            );

      sharedPlayerSlot = (i) => CardPackWidget(
        player: players[i]!,
        cardPack: players[i]?.pointDeck,
        cardHeight: cardHeight,
        cardWidth: cardWidth,
      );

      List<List<double?>> positions = [
        [0, null, 0, 50],
        [50, 0, null, 0],
        [0, 50, 0, null],
        [null, 0, 50, 0],
      ];
      boardCenter = () => Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < players.length; i++)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: selectedCards[i] != null ? positions[i][0] : null,
              top: selectedCards[i] != null ? positions[i][1] : null,
              right: selectedCards[i] != null ? positions[i][2] : null,
              bottom: selectedCards[i] != null ? positions[i][3] : null,
              child: selectedCards[i] != null
                  ? CardWidget(
                      player: players[i]!,
                      card: selectedCards[i],
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                    )
                  : Container(),
            ),
        ],
      );
    }
    /* GET TRICK WINNER */
    else if (controller.currentPhase == GamePhase.getTrickWinner) {
      controller.game.round.lookForTrickWinner();
      if (players[0]!.deck.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.nextPhase(true);
        });
      } else {
        controller.delaySequence(true);
      }

      // Widgets
      sharedPlayerArea = (i) => i != 0
          ? SpreadCardPackWidget(
              player: players[i]!,
              showOpponentCards: showOpponentCards,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {},
            )
          : HorizontallySpreadCardPackWidget(
              player: players[i]!,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {},
            );

      sharedPlayerSlot = (i) => CardPackWidget(
        player: players[i]!,
        cardPack: players[i]?.pointDeck,
        cardHeight: cardHeight,
        cardWidth: cardWidth,
      );

      List<List<double?>> positions = [
        [0, null, 0, 50],
        [50, 0, null, 0],
        [0, 50, 0, null],
        [null, 0, 50, 0],
      ];
      boardCenter = () => Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < players.length; i++)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: selectedCards[i] != null ? positions[i][0] : null,
              top: selectedCards[i] != null ? positions[i][1] : null,
              right: selectedCards[i] != null ? positions[i][2] : null,
              bottom: selectedCards[i] != null ? positions[i][3] : null,
              child: selectedCards[i] != null
                  ? CardWidget(
                      player: players[i]!,
                      card: selectedCards[i],
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                    )
                  : Container(),
            ),
        ],
      );
    }
    /* END OF ROUND */
    else if (controller.currentPhase == GamePhase.endOfRound) {
      Player winner = controller.game.round.lookForRoundWinner();
      if (controller.game.round.roundNumber ==
          controller.game.round.roundCount - 1) {
        showOpponentCards = true;
        showMainPlayerCards = false;
      }
      if (controller.game.round.roundNumber ==
          controller.game.round.roundCount) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.nextPhase(true);
        });
      } else {
        bool hasNextRound = controller.game.round.nextRound(winner);
        if (!hasNextRound) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.nextPhase(true);
          });
        } else {
          controller.delaySequence(true);
        }
      }

      // Widgets
      sharedPlayerArea = (i) => i != 0
          ? SpreadCardPackWidget(
              player: players[i]!,
              showOpponentCards: showOpponentCards,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {},
            )
          : HorizontallySpreadCardPackWidget(
              player: players[i]!,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {},
            );

      sharedPlayerSlot = (i) => CardPackWidget(
        player: players[i]!,
        cardPack: players[i]?.pointDeck,
        cardHeight: cardHeight,
        cardWidth: cardWidth,
      );

      List<List<double?>> positions = [
        [0, null, 0, 50],
        [50, 0, null, 0],
        [0, 50, 0, null],
        [null, 0, 50, 0],
      ];
      boardCenter = () => Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < players.length; i++)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: selectedCards[i] != null ? positions[i][0] : null,
              top: selectedCards[i] != null ? positions[i][1] : null,
              right: selectedCards[i] != null ? positions[i][2] : null,
              bottom: selectedCards[i] != null ? positions[i][3] : null,
              child: selectedCards[i] != null
                  ? CardWidget(
                      player: players[i]!,
                      card: selectedCards[i],
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                    )
                  : Container(),
            ),
        ],
      );
    }
    /* END OF GAME */
    else if (controller.currentPhase == GamePhase.endOfGame) {
      Player winner = controller.game.round.lookForGameWinner();

      // Widgets
      sharedPlayerArea = (i) => i != 0
          ? SpreadCardPackWidget(
              player: players[i]!,
              showOpponentCards: showOpponentCards,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {},
            )
          : HorizontallySpreadCardPackWidget(
              player: players[i]!,
              cardHeight: cardHeight,
              cardWidth: cardWidth,
              onTap: (cardIndex) {},
            );

      sharedPlayerSlot = (i) => CardPackWidget(
        player: players[i]!,
        cardPack: players[i]?.pointDeck,
        cardHeight: cardHeight,
        cardWidth: cardWidth,
      );

      boardCenter = () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${winner.name} won !"),
            ElevatedButton(
              child: Text("Restart ?"),
              onPressed: () => setState(() {
                controller.nextPhase(false);
              }),
            ),
          ],
        ),
      );
    }

    Widget leftPlayerArea() {
      return sharedPlayerArea(1);
    }

    Widget topPlayerArea() {
      return sharedPlayerArea(2);
    }

    Widget rightPlayerArea() {
      return sharedPlayerArea(3);
    }

    Widget bottomPlayerArea() {
      return sharedPlayerArea(0);
    }

    Widget leftPlayerSlot() {
      return sharedPlayerSlot(1);
    }

    Widget topPlayerSlot() {
      return sharedPlayerSlot(2);
    }

    Widget rightPlayerSlot() {
      return sharedPlayerSlot(3);
    }

    Widget bottomPlayerSlot() {
      return sharedPlayerSlot(0);
    }

    Widget boardWidget = Center(
      child: Container(
        color: Colors.green.shade900,
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
                        child: topPlayerArea(),
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
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              border: Border.all(
                                width: paddings,
                                color: Colors.green.shade300,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            margin: EdgeInsets.all(margins),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: PlayerWidget(
                                          player: players[2]!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: PlayerWidget(
                                          player: players[1]!,
                                        ),
                                      ),
                                      Expanded(
                                        child: PlayerWidget(
                                          player: players[3]!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: PlayerWidget(
                                          player: players[0]!,
                                        ),
                                      ),
                                    ],
                                  ),
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
                        child: bottomPlayerArea(),
                      ),
                    ),
                    Expanded(flex: 1, child: bottomPlayerSlot()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return boardWidget;
  }
}
