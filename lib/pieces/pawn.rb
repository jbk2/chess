# require_relative 'piece'

class Pawn < Piece
  
  attr_accessor :colour, :x, :y

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end