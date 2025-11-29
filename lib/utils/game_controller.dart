import 'package:flutter/material.dart';
import 'package:tarot_africain/models/game.dart';

enum GamePhase {
  initGame,
  choosePointCardPack,
  placeBids,
  placeCards,
  endOfRound,
}

class GameController extends ChangeNotifier {
  Game game;
  GamePhase currentPhase = GamePhase.initGame;

  GameController(this.game);

  void startInitGameSequence() async {
    await Future.delayed(Duration(seconds: 2));
    nextPhase();
  }

  void nextPhase() {
    switch(currentPhase) {
      case GamePhase.initGame:
        currentPhase = GamePhase.choosePointCardPack;
        break;
      case GamePhase.choosePointCardPack:
        currentPhase = GamePhase.placeBids;
        break;
      case GamePhase.placeBids:
        currentPhase = GamePhase.placeCards;
        break;
      case GamePhase.placeCards:
        currentPhase = GamePhase.endOfRound;
        break;
      case GamePhase.endOfRound:
        currentPhase = GamePhase.initGame;
        break;
    }
    notifyListeners();
  }
}
