require_relative 'piece'

class Bishop < Piece
  attr_accessor :colour, :x, :y

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end