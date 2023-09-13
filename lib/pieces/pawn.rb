require_relative 'piece'

class Pawn < Piece
  attr_accessor :r, :c
  attr_reader :black_char, :white_char, :colour
  attr_writer :first_move

  BLACK_CHAR = "\u265F"
  WHITE_CHAR = "\u2659"

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
    valid_pawn_moves(src, board).include?(dst)
  end

  # implements diagonal taking move logic, 1st move 2 square logic, clear path logic and not into own piece logic.
  def valid_pawn_moves(src, board)
    moves = []
    if @colour == :white 
      # straight white moves
      if first_move?
        moves << [r-1, c] if Board.valid_coord?(r-1, c) && board.empty_square?(r-1, c)
        moves << [r-2, c] if Board.valid_coord?(r-2, c) && board.empty_square?(r-1, c) && board.empty_square?(r-2, c)
      else
        moves << [r-1, c] if Board.valid_coord?(r-1, c) && board.empty_square?(r-1, c)
      end
      # diagonal white moves
      if Board.valid_coord?(r-1, c-1)
        moves << [r-1, c-1] if board.opponent_piece?(r-1, c-1, @colour)
      end
      if Board.valid_coord?(r-1, c+1)
        moves << [r-1, c+1] if board.opponent_piece?(r-1, c+1, @colour)
      end
    else # must be a :black piece
      # straight black moves
      if first_move?
        moves << [r+1, c] if Board.valid_coord?(r+1, c) && board.empty_square?(r+1, c)
        moves << [r+2, c] if Board.valid_coord?(r+2, c) && board.empty_square?(r+1, c) && board.empty_square?(r+2, c)
      else
        moves << [r+1, c] if Board.valid_coord?(r+1, c) && board.empty_square?(r+1, c)
      end
      # diagonal black moves
      if Board.valid_coord?(r+1, c-1)
        moves.push([r+1, c-1]) if board.opponent_piece?(r+1, c-1, @colour)
      end
      if Board.valid_coord?(r+1, c+1)
        moves.push([r+1, c+1]) if board.opponent_piece?(r+1, c+1, @colour)
      end
    end
    moves
    # if reached_end_row #promote - NOT DONE
    # if first_move_double_step then set @passantable to true NOT DONE
  end
  
  def promotable?(r, c)
    (@colour == :white && r == 0) || (@colour == :black && r == 7) ? true : false
  end

end

# ## MOVE RULES
# 1. on 1st move; Can move 2 square forward, on all other moves only one square.
# 2. can only capture with a diagonal forward move & may only move diagonally, by 1 square, if capturing.
# 3. cannot move or capture backwards (all other pieces can).
# 4. en-passant; after a pawn's double move from home row, if it moved to a square with
# an adjacent enemy pawn piece, that adjacent enemy pawn may move
# diagonally into the square jumped by the two step pawn and at the same time capture that
# two step moved pawn. Must be done immediately after the two step pawn move of the original pawn.
# 5. on reaching the opponent's end of board it is able to promote into player's choice of his own;
# queen, rook, knight or bishop (usually queen, not mandatory)