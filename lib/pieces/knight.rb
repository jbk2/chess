class Knight < Piece
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

  @@black_char = "\u2658"
  @@white_char = "\u265E"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end