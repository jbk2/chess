require_relative 'piece'

class Pawn < Piece
  attr_reader :black_char, :white_char
  attr_accessor :colour, :x, :y

 BLACK_CHAR = "\u265F"
 WHITE_CHAR = "\u2659"

  def initialize(colour, x, y)
    super(colour, x, y)
  end

  # def uni_char(colour)
  #   super
  # end

  def piece_valid_move?(move)
    # test whether given move is a valid move according to the piece's possible valid moves and a chess board of always 8x8
  end
  

end