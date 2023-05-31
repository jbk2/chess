class Rook < Piece

  attr_accessor :colour, :x, :y
  @@rook_black_char = "\u2656"
  @@rook_white_char = "\u265C"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end