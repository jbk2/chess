class Piece

  attr_reader :colour, :x, :y

  def initialize(colour, x, y)
    @colour = colour
    @x = x
    @y = y
  end

  def uni_char
    if colour == :white
      print(" | #{self.class.class_variable_get(:@@white_char)} #{self.class.to_s.chr}w| ")
    else
      print(" | #{self.class.class_variable_get(:@@black_char)} #{self.class.to_s.chr}b| ")
    end
  end

end