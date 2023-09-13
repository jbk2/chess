require_relative 'piece'

class Bishop < Piece
  attr_accessor :r, :c
  attr_reader :black_char, :white_char, :colour
  attr_writer :first_move

  BLACK_CHAR = "\u265D"
  WHITE_CHAR = "\u2657"

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
    src, dst = [move[0].to_i,move[1].to_i], [move[2].to_i,move[3].to_i]
    valid_bishop_moves(src, board).include?(dst)
  end

  # validates against move_path_clear & non-moving onto same colour piece.
  def valid_bishop_moves(src, board)
    game_valid_moves = []
    every_bishop_move.each do |dst|
      move = (src + dst).join
      game_valid_moves << dst if move_path_clear?(move, board) && !src_dst_same_colour?(move, board)
    end
    game_valid_moves
  end

  def every_bishop_move
    down_right_diag = (r+1..7).zip(c+1..7).delete_if { |e| e.include?(nil) }
    down_left_diag = (r+1..7).zip((0..c-1).to_a.reverse).delete_if {|e| e.include?(nil) }
    up_right_diag = ((0..r-1).to_a.reverse).zip(c+1..7).delete_if { |e| e.include?(nil) }
    up_left_diag = ((0..r-1).to_a.reverse).zip((0..c-1).to_a.reverse).delete_if { |e| e.include?(nil) }
    moves = down_right_diag + down_left_diag + up_right_diag + up_left_diag
  end

end

# ## Move rules:
# 1. only moves in straight diagonal line
# 2. cannot jump over any other pieces.
# 3. only ever on same colour square.
# 4. can move any number of squares, so long as 2 == true