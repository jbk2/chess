### CLI Chess implementation – The Odin Project - Ruby course capstone project:

## Usage
- Main running script written in the Game class, just run `ruby lib/game.rb` in your terminal to start.
- Written with TDD, just run `rspec` in your terminal.

## Points of note:
- User input error on move formats is with the 'front end' CLI user input tested for validity via conditional format checks and print messages to user. User input is checked on the back end before it's saved on the Player's @moves variable via creating exception objects of a custom InvalidUserInput class.
- Game#get_move implements user input validation for:
  - format, e.g. 'b1,c1'
  - actual move; i.e. moving fron one square to a different square
  - first move for player Pawn or Knight only.
  - in board 8x8 scope
- In board 8x8 scope validation is also implemented in #valid_class_moves generator method.

- Code DSL:
  - r = row
  - c = column
  - always row first then column (not chess move syntax uses c then r! (need to adapt code to this))
  - src_r, src_c = single integer values representing row or column, respectively, on chess board/grid.
  - src = an array of r and c integer values, representing a coordinate/square on the chess board/grid - also representing the beginning position of a move, e.g. [0, 0].
  - dst = an array of r and c integer values, representing a coordinate/square on the chess board/grid, also representing the end position of a move, e.g. [1, 0].
  - move = a 4 char string of numeric values representing src + dst joined, e.g. '0010'. 



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
  - introduce Error classes for why a move cannot be made, e.g. off board, against piece's rules, other piece blocks you, wrong colour square?

# #################### NEXT TODO'S ###############

  # Tidy up Game#make_move
  # Get game flow working
  # Check for taken king & therefore winner.
  # Get the board displaying in UI at correct times
  # Add row and column numbers in display board UI
  # Integration tests for game flor (#play)
  # Clean up code in Game class
  # Refactor code in Game class
  # Re-write user input to receive in chess notation (column, row) and interpolate into code notation (row, column)
  # Write save game function
  # Write pawn to end convert function
  # Write castling function.


## Potential Refactorings

- #active_player code perhaps move from Game to Player class?
- for black and white positions just a class variable or two arrays on Board?
- there's the concept of a move ('a1,b1', formatted into index '0111'), which is saved on the players @ moves. The Piece also has its own x and y variables, and the board.grid also hosts the pice objects in it;s x and y location. Can we eliminate the piece's x and y, and just use the board.grids locations, does a piece need to know its own location?
- Perhaps instead of individual piece classes inheriting from the Piece class I can turn that Piece class into a module and just extend it to all individual piece type classes?
_ Two types of errors are currently used, custom written methods e.g. in get_move and a custom InputError class as used in add_move and board#piece. Unify this into one error handling strategy.
- Use Struct objects to create x & y named variables for square values instead of keeping referring to array indexes.
- Must move chess move user input notation from row column to column row as truly given in a chess game.

