### CLI Chess implementation – The Odin Project - Ruby course capstone project:

## Usage
*The running script is located in lib/main.rb*
1. In your console navigate to the directory's root.
2. Then type `ruby lib/main.rb` to run the programme.
3. Follow the terminal prompts from there.

## Points of note:
- Fully written with TDD. Run `rspec` in your terminal and read the ~244 tests to familiarise yourself with the code base.
- All aspects are unit tested, except load and save functionality. Currently there are only limited integration tests.
- Front end user IO uses chess notation (source colrow, destination colrow, e.g. 'a2,a4'), which is converted into index format (rowcolrowcol, e.g. '6040') to work with the grid's 2d 8 arrays containing 8 elements. 
- User input errors handled mainly by custom written format checking rescue methods.
- Game#get_move implements user input validation for:
  - format, e.g. 'b1,c1'.
  - a real move; i.e. moving from one square to a different square.
  - first move rules.
  - in board 8x8 scope.
- Game#make_move calls the move's game and piece rule validation via the implementation in each piece class's #valid_move.
- Game rule checks are implemented in Game's #moves_into_check?, #checkmate?, #stalemate? and #king_taken methods, being called by Game#make_move.
- Player's turns toggle until Game's @game_finished is set to true by the Game's various game rule state checking methods (as mentioned in above point).
- Once moves are format, game rule and game state validated they're stored in Game's @moves array and taken pieces in @taken_pieces array.
- IO output helper methods are located in UiModule and IO string content is stored as YAML data in data.yml. IO is printed to console via UiModule#display_string which introduces a typing delay for nicer UX.
- Save & load logic is stored in the SaveAndLoadModule, logic being called via Game#old_or_new_game. Saved games are lovated in the ../Games/ directory.

## Code DSL:
- r = row
- c = column
- index format = row first then column (not chess notation which is the reverse).
- src_r, src_c = 0-7 integer for piece source row, 0-7 integer for piece source column.
- dst_r, dst_c = 0-7 integer for piece move destination row, 0-7 integer for piece move destination column.
- src = an array of r and c integer values, representing the moving piece's starting location, e.g. [0, 0].
- dst = an array of r and c integer values, representing the movind piece's destination location, e.g. [1, 0].
- move = a 4 char string of numeric values representing src + dst joined, e.g. '0010'. 

__________________________________________

## Potential Refactorings
- #active_player code perhaps move from Game to Player class?
- for black and white positions just a class variable or two arrays on Board?
- Eliminate a piece's x and y, and just look up location from board.grids, any benefit in a piece storing it's own location?
- Instead of individual piece classes inheriting from Piece class, turn Piece class into a module and extend it to all individual piece type classes?
- Two types of errors are currently used, custom written methods e.g. in get_move, and a custom InputError class as used in add_move and board#piece. Unify this into one error handling strategy.
- Use Struct objects to create x & y named variables for square values instead of keeping referring to array indexes.
- Better enforcement of public & private method visibility.
- Run Rubocop

## Next Todo's 
- Complete unit testing of Game#make_move.
- introduce Error classes for why a move cannot be made, e.g. off board, against piece's rules, other piece blocks you, wrong colour square?
- introduce more begin/rescue blocks (e.g.; file save, ... , ... , ...)
- Integration tests for game flow (#play)(?)
- Refactor code in Game class
- Write castling functionality.
- Write Pawn en-passant functionality.
- Write Pawn promotion functionality.
- Revisit all tests and refactor.
- Write integration tests.
- Build a GUI.