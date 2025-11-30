import 'package:flutter/material.dart';
import 'package:tarot_africain/models/game.dart';

enum GamePhase {
  initGame,
  distributePointCardPack,
  placeBids,
  placeCards,
  getTrickWinner,
  endOfRound,
  endOfGame,
}

class GameController extends ChangeNotifier {
  Game game;
  GamePhase currentPhase = GamePhase.initGame;

  GameController(this.game);

  void delaySequence(bool moveToNextPhase) async {
    await Future.delayed(Duration(seconds: 2));
    moveToNextPhase ? nextPhase(false) : null;
  }

  void startInitGameSequence() async {
    delaySequence(true);
  }

  void startDistributePointCardPackSequence() async {
    delaySequence(true);
  }

  void nextPhase(bool isEdgeCase) {
    switch(currentPhase) {
      case GamePhase.initGame:
        currentPhase = GamePhase.distributePointCardPack;
        break;
      case GamePhase.distributePointCardPack:
        currentPhase = GamePhase.placeBids;
        break;
      case GamePhase.placeBids:
        currentPhase = GamePhase.placeCards;
        break;
      case GamePhase.placeCards:
        currentPhase = GamePhase.getTrickWinner;
        break;
      case GamePhase.getTrickWinner:
        currentPhase = isEdgeCase ? GamePhase.endOfRound : GamePhase.placeCards;
        break;
      case GamePhase.endOfRound:
        currentPhase = isEdgeCase ? GamePhase.endOfGame : GamePhase.distributePointCardPack;
        break;
      case GamePhase.endOfGame:
        currentPhase = GamePhase.initGame;
        break;
    }
    notifyListeners();
  }
}
