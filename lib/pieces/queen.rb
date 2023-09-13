require_relative 'piece'

class Queen < Piece
  attr_writer :first_move
  attr_reader :black_char, :white_char, :colour
  attr_accessor :r, :c

  BLACK_CHAR = "\u265B"
  WHITE_CHAR = "\u2655"

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
    src,dst  = [move[0].to_i,move[1].to_i], [move[2].to_i,move[3].to_i]
    valid_queen_moves(src, board).include?(dst)
  end

  # validates against move_path_clear & non-moving onto same colour piece.
  def valid_queen_moves(src, board)
    game_valid_moves = []
    every_queen_move.each do |dst|
      move = (src + dst).join
      game_valid_moves << dst if move_path_clear?(move, board) && !src_dst_same_colour?(move, board)
    end
    game_valid_moves
  end
  
  def every_queen_move
    down_right = (r+1..7).zip(c+1..7).delete_if { |e| e.include?(nil) }
    down_left = (r+1..7).zip((0..c-1).to_a.reverse).delete_if {|e| e.include?(nil) }
    up_right = ((0..r-1).to_a.reverse).zip(c+1..7).delete_if { |e| e.include?(nil) }
    up_left = ((0..r-1).to_a.reverse).zip((0..c-1).to_a.reverse).delete_if { |e| e.include?(nil) }
  
    up = (0...r).zip(Array.new(r, c))
    down = (r+1..7).zip(Array.new(8-r, c))
    left = Array.new(c, r).zip(0..c)
    right = Array.new(7-c, r).zip(c+1..7)
  
    moves = down_right + down_left + up_right + up_left + up + down + left + right
  end
  
end

# ## MOVE RULES
# 1. Any stright or diagnonal direction, any number of squares (therefore can land on any colour square).
# 2. Cannot move over other her own or over other side's pieces.