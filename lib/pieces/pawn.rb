# require_relative 'piece'

class Pawn < Piece
  attr_accessor :colour, :x, :y

 @@pawn_black_char = "\u2659"
 @@pawn_white_char = "\u265f"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

  def uni_char
    colour == :white ? @@pawn_white_char : @@pawn_black_char
  end
  

end