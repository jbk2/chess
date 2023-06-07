# ## MOVE RULES
# - in any stright line any number of squares, therefore can sit on any colour square.
# - not over other pieces
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

  def first_move_made
    @first_move = false
  end

  def piece_valid_move?(move)
    # test whether given move is a valid move according to the piece's possible valid moves and a chess board of always 8x8
  end
end