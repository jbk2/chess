require_relative 'piece'

class Pawn < Piece
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

 @@black_char = "\u2659"
 @@white_char = "\u265F"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

  # def uni_char(colour)
  #   super
  # end
  

end