import './card.dart';
import './card_pack.dart';

enum PlayerPosition { left, top, right, bottom }

class Player {
  final String name;
  final PlayerPosition position;
  CardPack deck = CardPack([]);
  CardPack pointDeck = CardPack([]);
  int tricksBid = 0;
  int tricksWon = 0;
  int points = 14;

  Player(this.name, this.position);

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
    if (position == PlayerPosition.left) return 1;
    if (position == PlayerPosition.top) return 2;
    if (position == PlayerPosition.right) return 3;
    return 0;
  }

  bool get hasVerticalPosition {
    return position == PlayerPosition.top || position == PlayerPosition.bottom;
  }

  @override
  String toString() => name;
}
