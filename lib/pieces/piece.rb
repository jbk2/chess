require 'pry-byebug'

class Piece

  attr_reader :colour, :x, :y

  def initialize(colour, x, y)
    @colour = colour
    @x = x
    @y = y
  end

  def uni_char
    if colour == :white
      # print(" |\u{26AB}#{self.class::WHITE_CHAR}#{self.class.to_s.chr}| ")
      # self.class
      self.class::WHITE_CHAR
    else
      # print(" |\u{26AA}#{self.class::BLACK_CHAR}#{self.class.to_s.chr}| ")
      # self.class
      self.class::BLACK_CHAR
    end
  end

end