import './card_pack.dart';
import './player.dart';
import './round.dart';
import 'dart:math';

class Game {
  Map<int, Player> players;
  late Round round;
  int dealerIndex = 0;
  final CardPack initialCardPack = CardPack.playable();
  // Points card packs TODO make players chose which one to take
  final CardPack spadesCardpack = CardPack.spades();
  final CardPack heartsCardpack = CardPack.hearts();
  final CardPack diamondsCardpack = CardPack.diamonds();
  final CardPack clubsCardpack = CardPack.clubs();

  Random rng = Random();

  Game(this.players);

  void startGame() {
    while (round.roundNumber != round.roundCount) {
      // Each player bids, clockwise, dealer is last to bid
      int announcementsSum = 0;
      for (int i = 0; i < players.length; i++) {
        int playerIndex = (i+1) % players.length;
        int announcement = (playerIndex == dealerIndex) ? _announceWithRestriction(announcementsSum) : _announceNormally();
        announcementsSum += announcement;
        players[playerIndex]?.announceTrick(announcement);
      }

      // Cards are played until the pack is empty
      for (int roundCardCount = round.roundCount - round.roundNumber; roundCardCount >= 1; roundCardCount--) {
        // Each player plays a card
        for (var player in players.values) {
          round.placeCard(player);
        }

        // Get trick winner
        print("Le gagnant du pli est: ${round.lookForTrickWinner().name}");

        // TODO trick winner starts next round
        dealerIndex = (dealerIndex + 1) % players.length;

        // TODO an excuse lets the player chose any value
      }

      round.lookForRoundWinner();

      initialCardPack.pickAll(round.centerCards);
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
