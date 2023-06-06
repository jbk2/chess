require_relative 'piece'

class Bishop < Piece
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  BLACK_CHAR = "\u265D"
  WHITE_CHAR = "\u2657"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

  def piece_valid_move?(move)
    # test whether given move is a valid move according to the piece's possible valid moves and a chess board of always 8x8
  end
end

# ## Move rules:
# 1. only moves in straight diagonal line
# 2. cannot jump over any other pieces.
# 3. only ever on same colour square.
# 4. can move any number of squares, so long as 2 == true

 