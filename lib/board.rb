Dir[File.join(__dir__, 'pieces', '*.rb')].each { |file| require_relative file }
require_relative '../lib/errors/input_errors'

class Board
  attr_accessor :grid
  attr_reader :colour_grid

  def initialize
    @grid = build_grid
    @colour_grid = build_colour_grid
    populate_board
  end

  def build_grid
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    populate_pawns
    populate_rooks
    populate_knights
    populate_bishops
    populate_queens
    populate_kings
    # grid[0][4], grid[0][7], grid[2][5], grid[2][7] = Rook.new(:white, 0, 4), King.new(:black, 0, 7), Pawn.new(:white, 2, 5), King.new(:white, 2, 7)
  end

  def piece(r, c)
    if (0..7).include?(r && c)
      grid[r][c]
    else
      raise InputError.new("#{r},#{c} is not a valid coordinate. Try again...")
    end
  end

  def empty_square?(r, c)
    piece(r, c).nil? ? true : false
  end
  
  def square_colour(r, c)
    colour_grid[r][c]
  end
  
  def display_colour_grid_utf
    build_colour_grid
    colour_grid.each do |row|
      puts "\n\n"
      row.each do |square|
        print(" | #{square.inspect} | ")
      end
    end
    puts "\n\n"
  end

  def display_board_utf
    print "\n"
    print "  "
    ('a'..'h').each { |l| print "   #{l}   "}
    grid.each_with_index do |row, row_index|
      print "\n"
      print ((row_index - 8).abs).to_s + ' '
      row.each_with_index do |piece, column_index|
        if piece.nil?
          if colour_grid[row_index][column_index] == :black
            print("\033[40m| nil |\033[m")
          else
            print("\033[47m| nil |\033[m")
          end
        else
          if colour_grid[row_index][column_index] == :black
            print("\033[40m|#{piece.colour.to_s[0..1] + ' ' + piece.class.to_s[0..1]}|\033[m") #.to_s.chr
          else
            print("\033[47m|#{piece.colour.to_s[0..1] + ' ' + piece.class.to_s[0..1]}|\033[m")
          end
        end
      end
      print ' ' + ((row_index - 8).abs).to_s + "\n"
      print '  '
      row.each_with_index do |piece, column_index|
        if piece.nil?
          if colour_grid[row_index][column_index] == :black
            print("\033[40m|     |\033[m")
          else
            print("\033[47m|     |\033[m")
          end
        else
          if colour_grid[row_index][column_index] == :black
            print("\033[40m| #{colour_emoji(piece.colour) + piece.uni_char} |\033[m")
          else
            print("\033[47m| #{colour_emoji(piece.colour) + piece.uni_char} |\033[m")
          end
        end
      end
      print "\n"
    end
    print "  "
    ('a'..'h').each { |l| print "   #{l}   "}
    puts "\n\n"
  end

  def opponent_piece?(r, c, self_colour)
    piece(r, c).nil? || piece(r, c).colour == self_colour ? false : true
  end

  def own_piece?(r, c, self_colour)
    piece(r, c).colour == self_colour ? true : false
  end

  def self.valid_coord?(r, c)
    [r, c].all? { |e| (0..7).include?(e) } ? true : false
  end

  def find_pieces(type, colour)
    locations = []
    grid.each_with_index do |row, row_index|
      row.each_with_index do |piece, column_index|
        if (piece.is_a?(Object.const_get(type.capitalize)) && piece.colour == colour)
          locations << [row_index, column_index] 
        end
      end
    end
    locations
  end

  def all_pieces(colour)
    types = ['pawn', 'rook', 'knight', 'bishop', 'queen', 'king']
    locations = []
    types.each do |type|
      find_pieces(type, colour).each { |coord| locations << coord }
    end
    locations
  end

  private
  def build_colour_grid
    @colour_grid = Array.new(8) { Array.new(8) }
    colour_grid.map.with_index do |row, row_index|
      row.map!.with_index do |square, col_index|
        if row_index.even?
          col_index.even? ? square = :white : square = :black
        else
          col_index.odd? ? square = :white : square = :black
        end
      end
    end
  end

  def populate_pawns
    # grid[1][0] = Pawn.new(:black, 1, 0)
    grid[1].map!.with_index do |v, i|
      v = Pawn.new(:black, 1, i)
    end
    # grid[6][0] = Pawn.new(:white, 6, 0)
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

  def colour_emoji(colour)
    colour == :black ? "\u{26AB}" : "\u{26AA}"
  end

end

# ________ Old unused, but potentially helpful, methods _______________________

 # def display_board
  #   grid.each {|e| pp "#{e}"}
  # end

  # def display_piece(x,y)
  #   pp grid[x][y]
  # end
  
  # def display_piece_utf(x,y)
  #   puts grid[x][y].uni_char
  # end

  # def black_or_white(row, column)
  #   populate_board[row][column]
  # end
# b = Board.new
# p b.display_colour_grid_utf

# b = Board.new
# b.build_grid
# pp b.grid.inspect