# ## MOVE RULES
# - on 1st move; Can move 2 square forward, on all other moves only one square.
# - cannot capture with a forward move, i.e. if a piece directly in front of, he cannot move.
# - may move diagonally by 1 square only if taking an opponent's piece.
# - cannot move or capture backwards (all other pieces can).
# - en-passant; after a pawn's double move from home row, if it moved to a square with
# an adjacent enemy pawn piece, that adjacent enemy pawn may move
# diagonally into the square jumped by the two step pawn and at the same time take that
# two step moved pawn. Must be done immediately after the two step pawn move of the original pawn.
# - on reaching the opponent's end of board it is able to promote into player's choice of his own;
# queen, rook, knight or bishop (usually queen, not mandatory).   

require_relative 'piece'
# require_relative '../lib/board'

class Pawn < Piece
  attr_writer :first_move
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

 BLACK_CHAR = "\u265F"
 WHITE_CHAR = "\u2659"

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

  # def uni_char(colour)
  #   super
  # end

  def piece_valid_move?(move, board)
    destination_square = [move[2].to_i,move[3].to_i]
    all_pawn_moves(board).include?(destination_square)
  end


  def all_pawn_moves(board)
    moves = []
    if @colour == :white 
      # straight white moves
      if first_move?
        moves << [x-1, y] if board.valid_coord?(x-1, y) && board.empty_square?(x-1, y)
        moves << [x-2, y] if board.valid_coord?(x-2, y) && board.empty_square?(x-2, y)
      else
        moves << [x-1, y] if board.valid_coord?(x-1, y) && board.empty_square?(x-1, y)
      end
      # diagonal white moves
      if board.valid_coord?(x-1, y-1)
        moves << [x-1, y-1] if board.opponent_piece?(x-1, y-1, @colour)
      end
      if board.valid_coord?(x-1, y+1)
        moves << [x-1, y+1] if board.opponent_piece?(x-1, y+1, @colour)
      end
    else # must be a :black piece
      # straight black moves
      if first_move?
        moves << [x+1, y] if board.valid_coord?(x+1, y) && board.empty_square?(x+1, y)
        moves << [x+2, y] if board.valid_coord?(x+2, y) && board.empty_square?(x+2, y)
      else
        moves << [x+1, y] if board.valid_coord?(x+1, y) && board.empty_square?(x+1, y)
      end
      # diagonal black moves
      if board.valid_coord?(x+1, y-1)
        moves.push([x+1, y-1]) if board.opponent_piece?(x+1, y-1, @colour)
      end
      if board.valid_coord?(x+1, y+1)
        moves.push([x+1, y+1]) if board.opponent_piece?(x+1, y+1, @colour)
      end
    end
    moves
    # if first_move? x2 moves forward - DONE
    # else x1 square forward  - DONE
    # cannot move backwards - DONE
    # if reached_end_row #promote - 
    # if first_move_double_step then set @passantable to true
  end
  
  def promotable?(x, y)
    (@colour == :white && x == 0) || (@colour == :black && x == 7) ? true : false
  end
  
end