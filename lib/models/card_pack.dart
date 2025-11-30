import './card.dart';

class CardPack {
  List<Card> cards;

  CardPack(this.cards);

  factory CardPack.full() {
    List<Card> cards = [];

    for (var cardType in [CardType.spades, CardType.hearts, CardType.diamonds, CardType.clubs]) {
      for (int value = 1; value <= 10; value++) {
        cards.add(Card(cardType, value));
      }
      for (int value = 22; value <= 25; value++) {
        cards.add(Card(cardType, value));
      }
    }

    for (int value = 1; value <= 21; value++) {
      cards.add(Card(CardType.trumps, value));
    }

    cards.add(Card(CardType.excuse, 0));

    return CardPack(cards);
  }

  factory CardPack.playable() {
    List<Card> cards = [];

    for (int value = 1; value <= 21; value++) {
      cards.add(Card(CardType.trumps, value));
    }

    cards.add(Card(CardType.excuse, 0));

    return CardPack(cards);
  }

  factory CardPack.spades() {
    List<Card> cards = [];

    for (int value = 1; value <= 10; value++) {
      cards.add(Card(CardType.spades, value));
    }
    for (int value = 22; value <= 25; value++) {
      cards.add(Card(CardType.spades, value));
    }

    return CardPack(cards);
  }

  factory CardPack.hearts() {
    List<Card> cards = [];

    for (int value = 1; value <= 10; value++) {
      cards.add(Card(CardType.hearts, value));
    }
    for (int value = 22; value <= 25; value++) {
      cards.add(Card(CardType.hearts, value));
    }

    return CardPack(cards);
  }

  factory CardPack.diamonds() {
    List<Card> cards = [];

    for (int value = 1; value <= 10; value++) {
      cards.add(Card(CardType.diamonds, value));
    }
    for (int value = 22; value <= 25; value++) {
      cards.add(Card(CardType.diamonds, value));
    }

    return CardPack(cards);
  }

  factory CardPack.clubs() {
    List<Card> cards = [];

    for (int value = 1; value <= 10; value++) {
      cards.add(Card(CardType.clubs, value));
    }
    for (int value = 22; value <= 25; value++) {
      cards.add(Card(CardType.clubs, value));
    }

    return CardPack(cards);
  }

  void shuffle() {
    cards.shuffle();
  }

  void add(Card card) {
    cards.add(card);
  }

  void pickAll(Map<int, Card> centerCards) {
    cards.addAll(centerCards.values);
    centerCards.clear();
  }

  Card take([Card? card]) {
    if (card != null) {
      cards.remove(card);
      return card;
    } else {
      return cards.removeLast();
    }
  }

  Card peek() {
    if (cards.isEmpty) throw Exception("Deck is empty");
    return cards.last;
  }

  void belongsTo(int playerId) {
    for (Card card in cards) {
      card.belongsTo = playerId;
    }
  }

  bool get isEmpty => cards.isEmpty;

  @override
  String toString() => cards.toString();
}
