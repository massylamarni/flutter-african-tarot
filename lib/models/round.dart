import 'package:tarot_africain/models/card_pack.dart';

import './player.dart';
import './card.dart';

class Round {
  final List<Player> players;
  final int roundCount = 5;
  List<Card> centerCards = [];
  int roundNumber = 1;

  Round(this.players);

  void distributeCards(CardPack cardPack, int nbCards) {
    cardPack.shuffle();
    for (int i = 0; i < nbCards; i++) {
      for (var player in players) {
        if (cardPack.isEmpty) continue;
        player.receiveCard(cardPack.take());
      }
    }
  }

  void placeCard(Player player) {
    centerCards.add(player.deck.peek());
    player.playCard(player.deck.peek());
  }

  Player lookForTrickWinner() {
    Card maxCard = centerCards[0];
    Player winner = players[0];

    for (int i = 1; i < centerCards.length; i++) {
      if (_compareCards(centerCards[i], maxCard) > 0) {
        maxCard = centerCards[i];
      }
    }

    for (Player player in players) {
      if (player.deck.cards.contains(maxCard)) winner = player;
    }

    winner.tricksWon++;
    return winner;
  }

  Player lookForRoundWinner() {
    Player winner = players[0];

    for (var player in players) {
      player.updatePoints();
      if (player.points > winner.points) {
        winner = player;
      }
    }
    print("Le gagnant du round est: ${winner.name}");
    return winner;
  }

  void nextRound() {
    centerCards = [];
    roundNumber++;
  }

  int _compareCards(Card a, Card b) {
    if (a.cardType == CardType.excuse) return 1; // Excuse wins
    if (b.cardType == CardType.excuse) return -1;
    return a.cardValue.compareTo(b.cardValue);
  }
}
