require_relative 'board'
require_relative 'player'

class Game
  @@cmd_format = "\e[47m\e[0;30m"
  @@p1_format = "\e[34m"
  @@p2_format = "\e[32m"
  @@bold_white = "\e[1;37m"
  @@ansi_end = "\e[0m"

  attr_accessor :player_1, :player_2, :active_player
  attr_reader :board

  def initialize
    build_board
    create_players
    assign_colour
    @active_player = white_player
  end

  def build_board
    @board = Board.new
  end

  def create_players
    puts "Welcome to your new chess game players. Please tell me the 1st player's name?"
    @player_1 = Player.new(player_1_name)
    puts "hi #{@@p1_format + player_1.name + @@ansi_end}.\nAnd player 2's name please?:"
    @player_2 = Player.new(player_2_name)
    puts "hey there #{@@p2_format + player_2.name + @@ansi_end}."
  end

  def play_game
    # get players names
    # randomly choose colour
    # report colour
    # populate board
    # begin game
  end
  
  def assign_colour
    puts "#ok, randomly assigning a colour to you both now..."
    player_1.colour = random_colour
    sleep 1
    puts "ok #{@@p1_format + player_1.name + @@ansi_end}'s randomly assigned colour is #{@@bold_white + player_1.colour.to_s + @@ansi_end}"
    player_1.colour == :white ? player_2.colour = :black : player_2.colour = :white
    sleep 0.5
    puts "and #{@@p1_format + player_2.name + @@ansi_end}'s colour therefore is #{@@bold_white + player_2.colour.to_s + @@ansi_end}"
  end

  def game_setup
    puts "here's your board:"
    puts "\n\n"
    puts "#{@@p2_format + black_player.name + @@ansi_end} playing from black pieces at the top of the board"
    board.display_board_utf
    board_orientation = <<~EOF
      and #{@@p1_format + white_player.name + @@ansi_end} playing from white pieces at bottom of the board.
    EOF
    puts board_orientation
    puts "\n\n"
  end

  def start_game
    turn_instructions = <<~EOF
      When prompted to take a turn please type your move by piece's current position, comma,
      position to move piece to, e.g. b1,d1, then key return.
      EOF
    puts turn_instructions
  end

  def starting_player
    @active_player = white_player
  end

  def toggle_turn
    active_player == player_1 ? (self.active_player = player_2) : (self.active_player = player_1)
  end

  def white_player
    player_1.colour == :white ? player_1 : player_2
  end

  def black_player
    player_1.colour == :black ? player_1 : player_2
  end

  private
  def player_1_name
    $stdin.gets.chomp
  end
  
  def player_2_name
    $stdin.gets.chomp
  end

  def random_colour
    [:white, :black].sample
  end
  
end




  # b = Board.new
  # b.populate_board
  # # b.grid[1].each_with_index do |e, i|
  # #   e = Piece.new(:pawn, 1, i)
  # #   puts "#{e.y}"
  # # end
  # # b.grid[1][0] = Piece.new(:pawn, 1, 0)
  # # p = Piece.new(1,1,1)
  # # puts p.inspect
  # b.display_board_utf
  # b.display_piece(6,1)
  # b.display_piece_utf(6,1)
  # puts "heres grid[1] #{b.grid[1]}"
  # p board.inspect
  # pp "here my path; #{$:.inspect}"


# game = Game.new
# puts "active player is #{game.active_player.inspect}"
# puts "player 1 is #{game.player_1.inspect}"
# puts "white player is #{game.white_player.inspect}"
# puts '\n\n'
# game.toggle_turn
# puts "new active player is #{game.active_player.inspect}"
# puts "player 1 is #{game.player_1.inspect}"
# puts "black player is #{game.black_player.inspect}"

# game.colour_assignment
# game.game_setup