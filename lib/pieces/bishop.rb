require_relative 'piece'

class Bishop < Piece
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  BLACK_CHAR = "\u265D"
  WHITE_CHAR = "\u2657"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end