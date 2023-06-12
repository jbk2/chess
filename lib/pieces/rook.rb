# ## MOVE RULES
# - in any stright line any number of squares, therefore can sit on any colour square.
# - not over other pieces
# - Castling; if 1st move for king & rook & no pieces between them, can in one simultaneous move move king
# two squares towards rook, and rook move to square on opposite side of new king position. Cannot
# castle when either; king is in check, king moves through a check or king lands in check.
require_relative 'piece'

class Rook < Piece
  attr_writer :first_move
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

  BLACK_CHAR = "\u265C"
  WHITE_CHAR = "\u2656"

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

  def valid_rook_moves
    moves = ([x]*8).zip(0..7) + (0..7).zip([y]*8) - [[x ,y]]
  end

end