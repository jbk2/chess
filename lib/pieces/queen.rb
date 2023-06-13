# ## MOVE RULES
# - Any stright or diagnonal direction, any number of squares (therefore can be on any colour square).
# - Cannot move over other her own or over other sides pieces.
require_relative 'piece'

class Queen < Piece
  attr_writer :first_move
  attr_accessor :colour, :x, :y
  attr_reader :black_char, :white_char

  BLACK_CHAR = "\u265B"
  WHITE_CHAR = "\u2655"

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
    # test whether given move is a valid move according to the piece's possible valid moves and a chess board of always 8x8
  end

  def valid_queen_moves
    down_right = (x+1..7).zip(y+1..7).delete_if { |e| e.include?(nil) }
    down_left = (x+1..7).zip((0..y-1).to_a.reverse).delete_if {|e| e.include?(nil) }
    up_right = ((0..x-1).to_a.reverse).zip(y+1..7).delete_if { |e| e.include?(nil) }
    up_left = ((0..x-1).to_a.reverse).zip((0..y-1).to_a.reverse).delete_if { |e| e.include?(nil) }

    up = (0...x).zip(Array.new(x, y))
    down = (x+1..7).zip(Array.new(8-x, y))
    left = Array.new(y, x).zip(0..y)
    right = Array.new(7-y, x).zip(y+1..7)

    diagonal_moves = down_right + down_left + up_right + up_left
    straight_moves = up + down + left + right

    diagonal_moves + straight_moves
  end
end