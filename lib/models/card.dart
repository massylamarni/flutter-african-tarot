enum CardType { spades, hearts, diamonds, clubs, trumps, excuse }

class Card {
  final CardType cardType;
  int cardValue;
  int? belongsTo = 0;

  Card(this.cardType, this.cardValue);

  String get mapCardValue {
    if (cardValue >= 1 && cardValue <= 21) { // Trumps (Atouts) [1-21], Classic [1-14]
      if (cardType != CardType.trumps && cardValue == 1) return 'A'; // Ace
      return cardValue.toString(); 
    }
    if (cardValue == 22) return 'C'; // Cavalier
    if (cardValue == 23) return 'V'; // Valet
    if (cardValue == 24) return 'D'; // Dame
    if (cardValue == 25) return 'R'; // Roi
    return 'Exc';
  }

  String get mapCardType {
    if (cardType == CardType.hearts) return 'C';
    if (cardType == CardType.diamonds) return 'K';
    if (cardType == CardType.spades) return 'P';
    if (cardType == CardType.clubs) return 'T';
    if (cardType == CardType.trumps) return 'AT';
    return '';
  }

  String get cardBack => 'assets/cards/CaJ-TaroTv1-Dos.png';
  String get assetPath => 'assets/cards/CaJ-TaroTv1-${mapCardValue + mapCardType}.png';

  @override
  String toString() {
    if (cardType == CardType.excuse) return "Excuse";
    return "$cardValue de $cardType";
  }
}
