import './card.dart';
import './card_pack.dart';

enum PlayerPosition { left, top, right, bottom }

class Player {
  final int id;
  final String name;
  final PlayerPosition position;
  CardPack deck = CardPack([]);
  CardPack pointDeck = CardPack([]);
  int tricksBid = 0;
  int tricksWon = 0;
  int points = 14;

  Player(this.id, this.name, this.position);

  factory Player.voidPlayer() {
    Player voidPlayer = Player(-1, "VOID_PLAYER", PlayerPosition.bottom);
    voidPlayer.deck = CardPack.playable();
    return voidPlayer;
  }

  factory Player.heartsPlayer() {
    Player heartsPlayer = Player(-2, "HEARTS_PLAYER", PlayerPosition.bottom);
    heartsPlayer.deck = CardPack.hearts();
    return heartsPlayer;
  }

  factory Player.spadesPlayer() {
    Player spadesPlayer = Player(-3, "SPADES_PLAYER", PlayerPosition.bottom);
    spadesPlayer.deck = CardPack.spades();
    return spadesPlayer;
  }

  factory Player.clubsPlayer() {
    Player clubsPlayer = Player(-4, "CLUBS_PLAYER", PlayerPosition.bottom);
    clubsPlayer.deck = CardPack.clubs();
    return clubsPlayer;
  }

  factory Player.diamondsPlayer() {
    Player diamondsPlayer = Player(-5, "DIAMONS_PLAYER", PlayerPosition.bottom);
    diamondsPlayer.deck = CardPack.diamonds();
    return diamondsPlayer;
  }

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
