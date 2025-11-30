import 'package:tarot_africain/models/card_pack.dart';

import './player.dart';
import './card.dart';
import 'dart:math';


class Round {
  final Map<int, Player> players;
  final int roundCount = 5;
  Map<int, Card> centerCards = {};
  int roundNumber = 1;
  Random rng = Random();

  Round(this.players);

  void distributeCards(CardPack cardPack, int nbCards) {
    for (int i = 0; i <= nbCards; i++) {
      for (var player in players.values) {
        if (cardPack.isEmpty) continue;
        player.receiveCard(cardPack.take());
      }
    }
  }

  // Each player bids, clockwise, dealer is last to bid
  void bid(int dealerId, int mainPlayerId) {
    int announcementsSum = 0;
    for (int i = 0; i < players.length; i++) {
      int playerId = (dealerId + 1 + i) % players.length;
      if (playerId == mainPlayerId) continue;
      int announcement = (playerId == dealerId) ? _announceWithRestriction(announcementsSum) : _announceNormally();
      announcementsSum += announcement;
      players[playerId]?.announceTrick(announcement);
    }
  }

  // Cards are played until the pack is empty
  void placeCards(int mainPlayerId) {
    for (var player in players.values) {
      if (player.id == mainPlayerId) continue;
      placeCard(player);
    }

    // TODO trick winner starts next round
    // TODO an excuse lets the player chose any value
  }

  int _announceNormally() {
    return rng.nextInt(3); // "Le hasard fait bien les choses"
  }

  int _announceWithRestriction(int announcementsSum) {
    int randomAnnouncement = rng.nextInt(3);
    if (randomAnnouncement + announcementsSum == 5) {
      randomAnnouncement = randomAnnouncement + 1;
    }
    return randomAnnouncement;
  }

  void placeCard(Player player) {
    centerCards[player.id] = player.deck.peek();
    player.playCard(player.deck.peek());
  }

  Player lookForTrickWinner() {
    Card maxCard = centerCards[0]!;

    for (int i = 1; i < centerCards.length; i++) {
      if (_compareCards(centerCards[i]!, maxCard) > 0) {
        maxCard = centerCards[i]!;
      }
    }

    Player winner = players[maxCard.belongsTo]!;
    winner.tricksWon++;
    print("Le gagnant du pli est: ${winner.name}");
    return winner;
  }

  Player lookForRoundWinner() {
    Player winner = players[0]!;

    for (var player in players.values) {
      player.updatePoints();
      if (player.points > winner.points) {
        winner = player;
      }
    }
    print("Le gagnant du round est: ${winner.name}");
    return winner;
  }

  void nextRound() {
    for (Player player in players.values) {
      if (player.points < 0) {
        for (int i = 0; i < player.points.abs(); i++) {
          player.deck.take();
        }
      }
      player.tricksWon = 0;
      player.tricksBid = 0;
    }
    roundNumber++;
  }

  int get distributedCardCount {
    return roundCount - roundNumber;
  }

  int _compareCards(Card a, Card b) {
    if (a.cardType == CardType.excuse) return 1; // Excuse wins
    if (b.cardType == CardType.excuse) return -1;
    return a.cardValue.compareTo(b.cardValue);
  }
}
