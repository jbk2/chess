# ## MOVE RULES
# Can jump over other pieces
# L shaped two and one square moves
require_relative 'piece'
require_relative '../board'

class Knight < Piece
  attr_writer :first_move
  attr_reader :black_char, :white_char, :colour
  attr_accessor :r, :c

  BLACK_CHAR = "\u265E"
  WHITE_CHAR = "\u2658"

  def initialize(colour, r, c)
    @first_move = true
    super(colour, r, c)
  end

  def first_move?
    @first_move
  end

  def first_move_taken
    @first_move = false
  end
  
  def piece_valid_move?(move, board)
    destination_square = [move[2].to_i,move[3].to_i]
    all_knight_moves.include?(destination_square)
    # all_valid_knight_moves(board).include?(destination_square)
  end

  # def all_valid_knight_moves(move, board)
  #   all_moves = all_knight_moves
  #   all_moves.delete_if do |move|
  #     board.grid
  #   end
  # end

  def all_knight_moves
    moves = []
    moves.push([r+2, c+1],[r+2, c-1],[r-2, c+1],[r-2, c-1],[r+1, c+2],[r-1, c+2],[r+1, c-2],[r-1, c-2])
    moves.delete_if { |move| move[0] < 0 || move[1] < 0}
    return moves
  end
  
end