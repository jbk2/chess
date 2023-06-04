class Rook < Piece
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

  BLACK_CHAR = "\u265C"
  WHITE_CHAR = "\u2656"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end