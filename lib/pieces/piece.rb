class Piece

  attr_reader :colour, :x, :y

  def initialize(colour, x, y)
    @colour = colour
    @x = x
    @y = y
  end

end