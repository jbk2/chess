# ## MOVE RULES
# - in any stright line any number of squares, therefore can sit on any colour square.
# - not over other pieces
# - Castling; if 1st move for king & rook & no pieces between them, can in one simultaneous move move king
# two squares towards rook, and rook move to square on opposite side of new king position. Cannot
# castle when either; king is in check, king moves through a check or king lands in check.
require_relative 'piece'

class Rook < Piece
  attr_writer :first_move
  attr_reader :black_char, :white_char, :colour
  attr_accessor :r, :c

  BLACK_CHAR = "\u265C"
  WHITE_CHAR = "\u2656"

  def initialize(colour, r, c)
    @first_move = true
    super(colour, r, c)
  end

  def first_move?
    @first_move
  end

  def first_move_taken
    @first_move = false
  end

  def piece_valid_move?(move, board)
    destination_square = [move[2].to_i,move[3].to_i]
    all_rook_moves.include?(destination_square)
  end

  def all_rook_moves
    moves = ([r]*8).zip(0..7) + (0..7).zip([c]*8) - [[r ,c]]
  end

end