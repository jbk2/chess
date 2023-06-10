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

  def piece_valid_move?(move)
    # test whether given move is a valid move according to the piece's possible valid moves and a chess board of always 8x8
  end
end