# ## MOVE RULES
# - diagonally only, any length, therefore only ever on same colour square.
# - cannot jump over any other pieces.

require_relative 'piece'

class Bishop < Piece
  attr_writer :first_move
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  BLACK_CHAR = "\u265D"
  WHITE_CHAR = "\u2657"

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
    all_bishop_moves(board).include?(destination_square)
  end

  def all_bishop_moves
    down_right_diag = (x+1..7).zip(y+1..7).delete_if { |e| e.include?(nil) }
    down_left_diag = (x+1..7).zip((0..y-1).to_a.reverse).delete_if {|e| e.include?(nil) }
    up_right_diag = ((0..x-1).to_a.reverse).zip(y+1..7).delete_if { |e| e.include?(nil) }
    up_left_diag = ((0..x-1).to_a.reverse).zip((0..y-1).to_a.reverse).delete_if { |e| e.include?(nil) }
    moves = down_right_diag + down_left_diag + up_right_diag + up_left_diag
  end
end

# ## Move rules:
# 1. only moves in straight diagonal line
# 2. cannot jump over any other pieces.
# 3. only ever on same colour square.
# 4. can move any number of squares, so long as 2 == true


 