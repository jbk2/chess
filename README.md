### CLI Chess implementation – The Odin Project - Ruby course capstone project:

## Usage
- Main running script written in the Game class, just run `ruby lib/game.rb` in your terminal to start.
- Written with TDD, just run `rspec` in your terminal.

## Tasks
- Introduce concept of player moves;
  - script for user command
  - check for valid moves
  - accept or decline move
  - make move
    - move piece, delete any taken piece, check game_status, toggle active player
- build valid moves into each piece class;
  - piece_valid_moves
  - valid within board bounds
  - valid within squre colour rules
  - validity within context of other board piece types and positions
- Introduce concept of game status;
  - Check
  - Checkmate
  - Stalemate
- Introduce game saving feature;
  - serialise game, board & plater instances
  - save to file
  - reload from file


## Potential Refactorings

- #active_player code perhaps move from Game to Player class?
- for black and white positions just a class variable or two arrays on Board?
