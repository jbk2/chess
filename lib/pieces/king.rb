# ## MOVE RULES
# - Any one square straight or diagnonal (therefore can step on any colour)
# - Cannot move itself into a check position.
# - Castling; if 1st move for king & rook & no pieces between them, can in one simultaneous move move king
# two squares towards rook, and rook move to square on opposite side of new king position. Cannot
# castle when either; king is in check, king moves through a check or king lands in check.
require_relative 'piece'

class King < Piece
  attr_writer :first_move
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char
  
  BLACK_CHAR = "\u265A"
  WHITE_CHAR = "\u2654"


  def initialize(colour, x, y)
    @first_move = true
    super(colour, x, y)
  end

  def first_move?
    @first_move
  end

  def first_move_taken
    @first_move = false
  end

  def piece_valid_move?(move, board)
    destination_square = [move[2].to_i,move[3].to_i]
    all_king_moves(board).include?(destination_square)
  end

  def all_king_moves
    moves = []
    moves.push([x+1, y+1], [x+1, y-1], [x-1, y+1], [x-1, y-1], [x-1, y], [x+1, y], [x, y-1], [x, y+1])
    moves.delete_if { |move| !Board.valid_coord?(move[0], move[1]) }
    

    # Moves into check - NOT DONE
    # Castling - NOT DONE

  end

  def in_check?(x, y)
    # does this position appear in the #valid_moves of any of opponent's pieces next moves?
  end


end