# ## MOVE RULES
# - Any stright or diagnonal direction, any number of squares (therefore can be on any colour square).
# - Cannot move over other her own or over other sides pieces.
require_relative 'piece'

class Queen < Piece
  attr_writer :first_move
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  BLACK_CHAR = "\u265B"
  WHITE_CHAR = "\u2655"

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