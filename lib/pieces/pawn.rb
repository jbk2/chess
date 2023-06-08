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

  def first_move_made
    @first_move = false
  end

  # def uni_char(colour)
  #   super
  # end

  def piece_valid_move?(move)
    # test whether given move is a valid move according to the piece's possible valid moves and a chess board of always 8x8
    puts "returning false as placemat here"
    false
  end
  

end