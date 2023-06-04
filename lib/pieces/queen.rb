class Queen < Piece
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  BLACK_CHAR = "\u265B"
  WHITE_CHAR = "\u2655"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end