# ## MOVE RULES
# - Any stright or diagnonal direction, any number of squares (therefore can be on any colour square).
# - Cannot move over other her own or over other sides pieces.
require_relative 'piece'

class Queen < Piece
  attr_writer :first_move
  attr_accessor :colour, :r, :c
  attr_reader :black_char, :white_char

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

  def piece_valid_move?(move, board)
    destination_square = [move[2].to_i,move[3].to_i]
    all_queen_moves.include?(destination_square)
  end

  def all_queen_moves
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