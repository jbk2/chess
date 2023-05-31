require_relative 'piece'

class Knight < Piece
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

  @@black_char = "\u2658"
  @@white_char = "\u265E"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

  def all_knights_moves
    moves = []
    moves.push([x+2, y+1],[x+2, y-1],[x-2, y+1],[x-2, y-1],[x+1, y+2],[x-1, y+2],[x+1, y-2],[x-1, y-2])
    return moves
  end

end