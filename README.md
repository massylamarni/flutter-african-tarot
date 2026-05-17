# African Tarot

African Tarot is a variant of the traditional tarot card game, primarily transmitted orally, making its exact origins difficult to trace. Like classic tarot, it is a trick-taking game built around a **bidding system**: each round, players announce how many tricks they expect to win, and the goal is to fulfill that contract exactly.

---

## Gameplay Overview

### Players & Deck

The game supports **3 or 4 players** and uses a standard 78-card tarot deck:

| Card Type | Count | Description |
|-----------|-------|-------------|
| Suit cards | 56 | Four suits (clubs, spades, diamonds, hearts) - 2 through 10, Jack, Knight, Queen, King, Ace |
| Trumps | 21 | Numbered 1 (weakest) to 21 (strongest) |
| The Excuse | 1 | A joker worth from 0 to 22 |

### Setup

The suit cards are divided into 4 packs (one per suit), each sorted in descending order (Ace treated as 1, placed last). Each player receives one pack, placed face-up in front of them.

### Structure of a Game

A game is made up of **rounds**. Each round consists of **5 turns**. The dealer remains the same for all 5 turns within a round, then rotates clockwise.

Each turn proceeds as follows:

1. **Bidding** - Starting with the player to the dealer's left, each player announces how many tricks they intend to win.
2. **Playing** - Players play their cards in order, aiming to meet their bid.
3. **Scoring** - Points are tallied after all cards are played.

**Turn card counts:**

| Turn | Cards dealt |
|------|-------------|
| 1st  | 5 cards     |
| 2nd  | 4 cards     |
| 3rd  | 3 cards     |
| 4th  | 2 cards     |
| 5th  | 1 card *(blind)* |

> **Special rule for the last turn:** Players must not look at their own card - instead, they hold it up so everyone else can see it. Bids are then made with that constraint.

### Bidding Constraint

The sum of all bids **cannot equal** the number of cards in hand. This ensures at least one player cannot fulfill their contract. The last bidder is therefore often forced to choose a specific number to avoid the forbidden total.

**Example (4 players, 5 cards each):** If players bid 2, 1, and 1, the last player cannot bid 1 (2+1+1+1 = 5) and must choose 0, 2, or more.

### Scoring

- **Contract met** - No points lost
- **Contract missed** - Lose points equal to the difference between tricks won and tricks bid

**Example:** Bid 3, won 1 - lose 2 points.

### Winning

The game ends when any player reaches **0 points**. The player with the **most points remaining** wins.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart ≥ 3.0

### Installation

```bash
git clone https://github.com/your-username/african-tarot.git
cd african-tarot
flutter pub get
flutter run
```
