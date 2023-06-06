class Queen < Piece
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  BLACK_CHAR = "\u265B"
  WHITE_CHAR = "\u2655"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

  def piece_valid_move?(move)
    # test whether given move is a valid move according to the piece's possible valid moves and a chess board of always 8x8
  end
end