import './card_pack.dart';
import './player.dart';
import './round.dart';

class Game {
  Map<int, Player> players;
  late Round round;
  int dealerId = 0;
  final CardPack initialCardPack = CardPack.playable();
  final CardPack spadesCardpack = CardPack.spades();
  final CardPack heartsCardpack = CardPack.hearts();
  final CardPack diamondsCardpack = CardPack.diamonds();
  final CardPack clubsCardpack = CardPack.clubs();

  Game(this.players);  
}
