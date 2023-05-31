require_relative 'piece'

class Bishop < Piece
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  @@black_char = "\u2657"
  @@white_char = "\u265D"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

end