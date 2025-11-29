import './card.dart';
import './card_pack.dart';

enum PlayerPosition { left, top, right, bottom }

class Player {
  final String name;
  final PlayerPosition playerPosition;
  CardPack deck = CardPack([]);
  int tricksBid = 0;
  int tricksWon = 0;
  int points = 14;

  Player(this.name, this.playerPosition);

  void receiveCard(Card card) {
    deck.add(card);
  }

  Card playCard(Card card) {
    print("$name joue $card");
    return deck.take(card);
  }

  void announceTrick(int value) {
    print("$name annonce $value plis");
    tricksBid = value;
  }

  void updatePoints() {
    points = points - (tricksBid - tricksWon).abs();
  }

  int get mapPlayerPosition {
    if (playerPosition == PlayerPosition.left) return 1;
    if (playerPosition == PlayerPosition.top) return 2;
    if (playerPosition == PlayerPosition.right) return 3;
    return 0;
  }

  @override
  String toString() => name;
}
