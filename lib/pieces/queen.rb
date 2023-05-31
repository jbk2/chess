class Queen < Piece
  attr_accessor :colour, :x, :y
  @@queen_black_char = "\u2655"
  @@queen_white_char = "\u265B"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end