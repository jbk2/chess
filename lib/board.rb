Dir[File.dirname(__FILE__) + '/pieces/*.rb'].each {|file| require_relative file }

class Board
  attr_accessor :grid

  def initialize
    @grid = create_grid
  end

  def create_grid
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    populate_pawns
    populate_rooks
    populate_knights
    populate_bishops
    populate_queens
    populate_kings
  end
  
  def display_board
    grid.each {|e| pp "#{e}"}
  end

  def display_board_utf
    grid.each do |row|
      puts
      puts
       row.each do |piece|
        # puts "here's piece #{piece.inspect}"
        piece.nil? ? print(" | nil | ") : piece.uni_char
      end
    end
  end

  def display_piece(x,y)
    pp grid[x][y]
  end
  
  def display_piece_utf(x,y)
    puts grid[x][y].uni_char
  end
  
  def piece(x,y)
    grid[x][y]
  end

  private
  def populate_pawns
    grid[1].map!.with_index do |v, i|
      v = Pawn.new(:black, 1, i)
    end
    grid[6].map!.with_index do |v, i|
      v = Pawn.new(:white, 6, i)
    end
  end
 
  def populate_rooks
    grid[0][0] = Rook.new(:black, 0, 0)
    grid[0][7] = Rook.new(:black, 0, 7)
    grid[7][7] = Rook.new(:white, 7, 7)
    grid[7][0] = Rook.new(:white, 7, 0)
  end

  def populate_knights
    grid[0][1] = Knight.new(:black, 0, 1)
    grid[0][6] = Knight.new(:black, 0, 6)
    grid[7][6] = Knight.new(:white, 7, 6)
    grid[7][1] = Knight.new(:white, 7, 1)
  end

  def populate_bishops
    grid[0][2] = Bishop.new(:black, 0, 2)
    grid[0][5] = Bishop.new(:black, 0, 5)
    grid[7][5] = Bishop.new(:white, 7, 5)
    grid[7][2] = Bishop.new(:white, 7, 2)
  end
  
  def populate_queens
    grid[0][3] = Queen.new(:black, 0, 3)
    grid[7][3] = Queen.new(:white, 7, 3)
  end
  
  def populate_kings
    grid[0][4] = King.new(:black, 0, 4)
    grid[7][4] = King.new(:white, 7, 4)
  end

end

b = Board.new
b.populate_board
# # b.grid[1].each_with_index do |e, i|
# #   e = Piece.new(:pawn, 1, i)
# #   puts "#{e.y}"
# # end
# # b.grid[1][0] = Piece.new(:pawn, 1, 0)
# # p = Piece.new(1,1,1)
# # puts p.inspect
b.display_board_utf
# b.display_piece(6,1)
# b.display_piece_utf(6,1)
# puts "heres grid[1] #{b.grid[1]}"
# p board.inspect
# pp "here my path; #{$:.inspect}"