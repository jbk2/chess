require_relative 'piece'

class Rook < Piece
  attr_accessor :r, :c
  attr_reader :black_char, :white_char, :colour
  attr_writer :first_move

  BLACK_CHAR = "\u265C"
  WHITE_CHAR = "\u2656"

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
    valid_rook_moves(src, board).include?(dst)
  end

# validates against move_path_clear & not moving onto same colour piece.
  def valid_rook_moves(src, board)
    game_valid_moves = []
    every_rook_move.each do |dst|
      move = (src + dst).join
      game_valid_moves << dst if move_path_clear?(move, board) && !src_dst_same_colour?(move, board)
    end
    game_valid_moves
  end
  
  def every_rook_move
    moves = ([r]*8).zip(0..7) + (0..7).zip([c]*8) - [[r ,c]]
  end

end

# ## MOVE RULES
# 1. in any stright line any number of squares, therefore can sit on any colour square.
# 2. not over other pieces
# 3. Castling; if 1st move for king & rook & no pieces between them, can in one simultaneous move move king
# two squares towards rook, and rook move to square on opposite side of new king position. Cannot
# castle when either; king is in check, king moves through a check or king lands in check.