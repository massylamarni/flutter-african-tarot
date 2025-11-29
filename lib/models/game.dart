import './card_pack.dart';
import './player.dart';
import './round.dart';
import 'dart:math';

class Game {
  List<Player> players;
  int dealerIndex = 0;

  Random rng = Random();

  Game(this.players);

  void startGame() {
    // Initial card pack
    CardPack cardPack = CardPack.playable();
    cardPack.shuffle();

    // Points card packs TODO make players chose which one to take
    List<CardPack> pointCardPacks = [
      CardPack.spades(),
      CardPack.hearts(),
      CardPack.diamonds(),
      CardPack.clubs()
    ];

    // Decide who is the dealder TODO choose who is the dealer, lasts 5 rounds then gives role to left player.
    dealerIndex = 0;

    // Init rounds
    Round round = Round(players);

    while (round.roundNumber != round.roundCount) {
      // Distribute cards to players
      for (int roundCardCount = round.roundCount - round.roundNumber; roundCardCount >= 1; roundCardCount--) {
        round.distributeCards(cardPack, roundCardCount);
      }

      // Each player bids, clockwise, dealer is last to bid
      int announcementsSum = 0;
      for (int i = 0; i < players.length; i++) {
        int playerIndex = (i+1) % players.length;
        int announcement = (playerIndex == dealerIndex) ? _announceWithRestriction(announcementsSum) : _announceNormally();
        announcementsSum += announcement;
        players[playerIndex].announceTrick(announcement);
      }

      // Cards are played until the pack is empty
      for (int roundCardCount = round.roundCount - round.roundNumber; roundCardCount >= 1; roundCardCount--) {
        // Each player plays a card
        for (var player in players) {
          round.placeCard(player);
        }

        // Get trick winner
        print("Le gagnant du pli est: ${round.lookForTrickWinner().name}");

        // TODO trick winner starts next round
        dealerIndex = (dealerIndex + 1) % players.length;

        // TODO an excuse lets the player chose any value
      }

      round.lookForRoundWinner();

      cardPack.pickAll(round.centerCards);
      round.nextRound();
    }
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
}
