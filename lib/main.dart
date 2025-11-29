import 'package:flutter/material.dart';
import 'package:tarot_africain/models/game.dart';
import 'package:tarot_africain/models/player.dart';
import 'dart:math';

import './widgets/card_container_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Game game = Game([]);
  String? selectedCardPath;
  Alignment selectedCardAlignment = Alignment.center;
  final double cardAspectRatio = 250 / 481;
  bool cardInCenter = false;

  @override
  void initState() {
    super.initState();
    game = Game([
      Player("Player 1"),
      Player("Player 2"),
      Player("Player 3"),
      Player("Player 4")
    ]);

    game.startGame();
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double appBarHeight = kToolbarHeight; // default AppBar height
    final double footerHeight = kToolbarHeight;
    final double boardSize = min(
      screenSize.width,
      screenSize.height - appBarHeight - footerHeight,
    );
    final double cardHeight = boardSize * 1 / 4;
    final double cardWidth = cardHeight * cardAspectRatio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: SizedBox(
              width: boardSize,
              height: boardSize,
              child: Row(
                children: [
                  Expanded(
                    // Left
                    flex: 1,
                    child: CardContainer(
                      cardImagePath: 'assets/cards/CaJ-TaroTv1-1AT.png',
                      quarterTurns: 1,
                      onTap: () {
                        setState(() {
                          selectedCardPath = 'assets/cards/CaJ-TaroTv1-1AT.png';
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
                          child: CardContainer(
                            cardImagePath: 'assets/cards/CaJ-TaroTv1-1AT.png',
                            quarterTurns: 2,
                            onTap: () {
                              setState(() {
                                selectedCardPath =
                                    'assets/cards/CaJ-TaroTv1-1AT.png';
                              });
                            },
                          ),
                        ),
                        Expanded(
                          // Center
                          flex: 2,
                          child: Stack(
                            children: [
                              Container(color: Colors.green.shade300),
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                top: cardInCenter ? 50 : 0,
                                bottom: cardInCenter ? null : 0,
                                left: cardInCenter ? 0 : null,
                                right: cardInCenter ? 0 : null,
                                child: CardContainer(
                                  cardImagePath:
                                      'assets/cards/CaJ-TaroTv1-1AT.png',
                                  quarterTurns: 2,
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
                          child: CardContainer(
                            cardImagePath: 'assets/cards/CaJ-TaroTv1-1AT.png',
                            quarterTurns: 0,
                            onTap: () {
                              setState(() {
                                selectedCardPath =
                                    'assets/cards/CaJ-TaroTv1-1AT.png';
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
                    child: CardContainer(
                      cardImagePath: 'assets/cards/CaJ-TaroTv1-1AT.png',
                      quarterTurns: 3,
                      onTap: () {
                        setState(() {
                          selectedCardPath = 'assets/cards/CaJ-TaroTv1-1AT.png';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: kToolbarHeight,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
