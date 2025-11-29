import './card.dart';
import './card_pack.dart';

class Player {
  final String name;
  CardPack deck = CardPack([]);
  int tricksBid = 0;
  int tricksWon = 0;
  int points = 14;

  Player(this.name);

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

  @override
  String toString() => name;
}
