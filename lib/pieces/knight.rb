require_relative 'piece'

class Knight < Piece
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

  BLACK_CHAR = "\u265E"
  WHITE_CHAR = "\u2658"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

  def valid_knights_moves
    moves = []
    moves.push([x+2, y+1],[x+2, y-1],[x-2, y+1],[x-2, y-1],[x+1, y+2],[x-1, y+2],[x+1, y-2],[x-1, y-2])
    moves.delete_if { |move| move[0] < 0 || move[1] < 0}
    return moves
  end

  def piece_valid_move?(move)
    destination_square = [move[2].to_i,move[3].to_i]
    valid_knights_moves.include?(destination_square)
  end

end