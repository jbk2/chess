class Queen < Piece
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  @@black_char = "\u2655"
  @@white_char = "\u265B"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end