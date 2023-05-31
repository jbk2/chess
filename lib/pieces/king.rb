class King < Piece
  attr_accessor :colour, :x, :y
  @@king_black_char = "\u2654"
  @@king_white_char = "\u265A"


  def initialize(colour, x, y)
    super(colour, x, y)
  end

end