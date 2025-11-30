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
      CardPack cardPack = players[playerId]!.deck;
      int announcement = (playerId == dealerId) ? _announceWithRestriction(cardPack, announcementsSum) : _announceNormally(cardPack);
      announcementsSum += announcement;
      players[playerId]?.announceTrick(announcement);
    }
  }

  int _announceNormally(CardPack cardPack) {
    const int BIG_CARD_START_RANGE = 12;
    final int playerAffinity = rng.nextInt(8);
    int bigCardsCount = 0;
    for (Card card in cardPack.cards) {
      if (card.cardValue > (BIG_CARD_START_RANGE + playerAffinity)) bigCardsCount++;
    }
    return bigCardsCount;
  }

  int _announceWithRestriction(CardPack cardPack, int announcementsSum) {
    int announcement= _announceNormally(cardPack);
    if (announcement+ announcementsSum == 5) {
      announcement= announcement + (rng.nextInt(1) == 0 ? -1 : 1);
    }
    return announcement;
  }

  // Cards are played until the pack is empty
  void placeCards(int mainPlayerId) {
    for (var player in players.values) {
      if (player.id == mainPlayerId) continue;
      
      int cardCount = player.deck.cards.length;
      Card placedCard;
      if (cardCount <= 1) {
        placedCard = player.deck.peek();
      } else {
        placedCard = player.deck.cards[rng.nextInt(cardCount - 1)]; // "Le hasard fait bien les choses"
      }
      
      centerCards[player.id] = placedCard;
      player.playCard(placedCard);
    }

    // TODO trick winner starts next round
    // TODO an excuse lets the player chose any value
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
      if (player.getTrickPoints() > winner.getTrickPoints()) {
        winner = player;
      }
      player.updatePoints();
    }
    print("Le gagnant du round est: ${winner.name}");
    return winner;
  }

  Player lookForGameWinner() {
    Player winner = players[0]!;

    for (var player in players.values) {
      if (player.points > winner.points) {
        winner = player;
      }
      player.updatePoints();
    }
    print("Le gagnant du jeu est: ${winner.name}");
    return winner;
  }

  bool nextRound(Player winner) {
    for (Player player in players.values) {
      if (player == winner) {
        player.tricksWon = 0;
        player.tricksBid = 0;
        continue;
      }
      if (player.points <= 0) return false;
      if (player.points < player.pointDeck.cards.length) {
        for (int i = player.points; i < player.pointDeck.cards.length; i++) {
          player.pointDeck.take();
        }
      }
      player.tricksWon = 0;
      player.tricksBid = 0;
    }
    roundNumber++;
    return true;
  }

  int get distributedCardCount {
    return roundCount - roundNumber;
  }

  int _compareCards(Card a, Card b) {
    if (a.cardType == CardType.excuse && a.cardValue == 0) {
      return 1;
    }
    if (b.cardType == CardType.excuse && a.cardValue == 0) {
      return -1;
    }
    return a.cardValue.compareTo(b.cardValue);
  }
}
