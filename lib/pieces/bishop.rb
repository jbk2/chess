require_relative 'piece'

class Bishop < Piece
  attr_accessor :colour, :x, :y
  @@bishop_black_char = "\u2657"
  @@bishop_white_char = "\u265D"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end