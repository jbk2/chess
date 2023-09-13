### CLI Chess implementation – The Odin Project - Ruby course capstone project:

## Usage
* Running script written in lib/main.rb *
1. In your console navigate to the directory's root.
2. Then type `ruby lib/game.rb` to run the programme.
3. Follow terminal prompts from there.

## Points of note:
- Written with TDD, just run `rspec` in your terminal and read the ~244 odd tests to familiarise yourself with code structure.
- All aspects, except load and save functionality, are unit tested. Currently there are only limited integration tests.
- User input errors handled mainly by custom written format checking rescue methods.
- Game#get_move implements user input validation for:
  - format, e.g. 'b1,c1'
  - actual move; i.e. moving fron one square to a different square
  - first move for player Pawn or Knight only.
  - in board 8x8 scope (& in #valid_class_moves).
- Once moves are format, game rule and game state validated they're stored, with taken pieces, in Game's @moves.
- Front end user IO uses chess notation (source colrow, destination colrow, e.g. 'a2,a4'), which is converted into index format (rowcolrowcol, e.g. '6040') to work with the grid's 2d 8 arrays containing 8 elements. 

## Code DSL:
- r = row
- c = column
- index format always row first then column (not chess notation which uses the reverse).
- src_r, src_c = 0-7 integer for piece source row, 0-7 integer for piece source column.
- dst_r, dst_c = 0-7 integer for piece move destination row, 0-7 integer for piece move destination column.
- src = an array of r and c integer values, representing the moving piece's starting location, e.g. [0, 0].
- dst = an array of r and c integer values, representing the movind piece's destination location, e.g. [1, 0].
- move = a 4 char string of numeric values representing src + dst joined, e.g. '0010'. 
  
__________________________________________

## NEXT TODO'S 
  - remove commented code
  - introduce Error classes for why a move cannot be made, e.g. off board, against piece's rules, other piece blocks you, wrong colour square?
  - introduce more begin/rescue blocks (e.g.; file save, ... , ... , ...)
  - Integration tests for game flow (#play)(?)
  - Clean up code in Game class
  - Refactor code in Game class
  - Write castling function.

## Potential Refactorings
- #active_player code perhaps move from Game to Player class?
- for black and white positions just a class variable or two arrays on Board?
- Eliminate a piece's x and y, and just look up location from board.grids, any benefit in a piece storing it's own location?
- Instead of individual piece classes inheriting from Piece class, turn Piece class into a module and extend it to all individual piece type classes?
- Two types of errors are currently used, custom written methods e.g. in get_move, and a custom InputError class as used in add_move and board#piece. Unify this into one error handling strategy.
- Use Struct objects to create x & y named variables for square values instead of keeping referring to array indexes.
