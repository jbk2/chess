require_relative 'piece'

class King < Piece
  attr_accessor :r, :c
  attr_reader :black_char, :white_char, :colour
  attr_writer :first_move
  
  BLACK_CHAR = "\u265A"
  WHITE_CHAR = "\u2654"


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
    valid_king_moves(src, board).include?(dst)
  end

# validates against move_path_clear & non-moving onto own piece.
  def valid_king_moves(src, board)
    game_valid_moves = []
    every_king_move.each do |dst|
      move = (src + dst).join
      game_valid_moves << dst if move_path_clear?(move, board) && !src_dst_same_colour?(move, board)
    end
    game_valid_moves
  end

  def every_king_move
    moves = []
    moves.push([r+1, c+1], [r+1, c-1], [r-1, c+1], [r-1, c-1], [r-1, c], [r+1, c], [r, c-1], [r, c+1])
    moves.delete_if { |move| !Board.valid_coord?(move[0], move[1]) }
    # Castling - NOT DONE
  end

end

# ## MOVE RULES
# 1. Any one square straight or diagnonal (therefore can step on any colour)
# 2. Cannot move itself into a check position.
# 3. Castling; if 1st move for king & rook & no pieces between them, can in one simultaneous move move king
# two squares towards rook, and rook move to square on opposite side of new king position. Cannot
# castle when either; king is in check, king moves through a check or king lands in check.