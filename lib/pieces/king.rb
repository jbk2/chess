# ## MOVE RULES
# - Any one square straight or diagnonal (therefore can step on any colour)
# - Cannot move itself into a check position.
# - Castling; if 1st move for king & rook & no pieces between them, can in one simultaneous move move king
# two squares towards rook, and rook move to square on opposite side of new king position. Cannot
# castle when either; king is in check, king moves through a check or king lands in check.
require_relative 'piece'

class King < Piece
  attr_writer :first_move
  attr_reader :black_char, :white_char, :colour
  attr_accessor :r, :c
  
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

  def piece_valid_move?(move, board)
    destination_square = [move[2].to_i,move[3].to_i]
    valid_king_moves(move, board).include?(destination_square)
  end

# validates against move_path_clear & non-moving to same colour piece space.
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
    # Moves into check - NOT DONE
    # Castling - NOT DONE
  end

  def in_check?(r, c)
    # does this position appear in the #valid_moves of any of opponent's pieces next moves?
  end


end