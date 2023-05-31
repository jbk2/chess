class King < Piece
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char
  
  @@black_char = "\u2654"
  @@white_char = "\u265A"


  def initialize(colour, x, y)
    super(colour, x, y)
  end

end