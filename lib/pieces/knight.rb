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
  
  def valid_move?(move, board)
    dst = [move[2].to_i,move[3].to_i]
    src = [move[0].to_i,move[1].to_i]
    valid_knight_moves(src, board).include?(dst)
  end

  # validates against non-moving to same colour piece space.
  def valid_knight_moves(src, board)
    game_valid_moves = []
    every_knight_move.each do |dst|
      move = (src + dst).join
      game_valid_moves << dst if !src_dst_same_colour?(move, board)
    end
    game_valid_moves
  end

  def every_knight_move
    moves = []
    moves.push([r+2, c+1],[r+2, c-1],[r-2, c+1],[r-2, c-1],[r+1, c+2],[r-1, c+2],[r+1, c-2],[r-1, c-2])
    moves.delete_if { |move| (!(0..7).include?(move[0])) || (!(0..7).include?(move[1])) } # alternatively; moves.delete_if { |move| (move[0] < 0 || move[0] > 7) || (move[1] < 0 || move[1] > 7) }
    return moves
  end

end