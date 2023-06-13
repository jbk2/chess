# ## MOVE RULES
# Can jump over other pieces
# L shaped two and one square moves
require_relative 'piece'

class Knight < Piece
  attr_writer :first_move
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

  BLACK_CHAR = "\u265E"
  WHITE_CHAR = "\u2658"

  def initialize(colour, x, y)
    @first_move = true
    super(colour, x, y)
  end

  def first_move?
    @first_move
  end

  def first_move_taken
    @first_move = false
  end
  
  def piece_valid_move?(move)
    destination_square = [move[2].to_i,move[3].to_i]
    all_knight_moves.include?(destination_square)
  end

  def all_knight_moves
    moves = []
    moves.push([x+2, y+1],[x+2, y-1],[x-2, y+1],[x-2, y-1],[x+1, y+2],[x-1, y+2],[x+1, y-2],[x-1, y-2])
    moves.delete_if { |move| move[0] < 0 || move[1] < 0}
    return moves
  end

end