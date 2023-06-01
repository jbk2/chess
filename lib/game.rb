require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :player_1, :player_2, :active_player
  attr_reader :board

  @@cmd_format = "\e[47m\e[0;30m"
  @@blue = "\e[34m"
  @@green = "\e[32m"
  @@bold_white = "\e[1;37m"
  @@cyan = "\e[0;36m"
  @@ansi_end = "\e[0m"
  @@type_speed = 0.02
  


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
    display_string("Welcome to your new chess game players. Please tell me the 1st player's name?", 0.01)
    @player_1 = Player.new(player_1_name)
    display_string("hi #{@@blue + player_1.name + @@ansi_end} \u{1F44B}\n", @@type_speed)
    sleep 0.3
    display_string("\nAnd player 2's name please?:", @@type_speed)
    @player_2 = Player.new(player_2_name)
    display_string("hey there #{@@green + player_2.name + @@ansi_end}.\u{1F91D}\n\n", @@type_speed)
  end

  def play_game
    # get players names
    # randomly choose colour
    # report colour
    # populate board
    # begin game
  end
  
  def assign_colour
    display_string("#ok, randomly assigning a colour to you both now...\n\n", @@type_speed)
    # puts "#ok, randomly assigning a colour to you both now...\n\n"
    player_1.colour = random_colour
    sleep 1
    display_string("ok #{@@blue + player_1.name + @@ansi_end}'s randomly assigned colour is #{@@bold_white + player_1.colour.to_s + @@ansi_end}\n\n", @@type_speed)
    # puts "ok #{@@blue + player_1.name + @@ansi_end}'s randomly assigned colour is #{@@bold_white + player_1.colour.to_s + @@ansi_end}\n\n"
    player_1.colour == :white ? player_2.colour = :black : player_2.colour = :white
    sleep 0.5
    display_string("and #{@@green + player_2.name + @@ansi_end}'s colour therefore is #{@@bold_white + player_2.colour.to_s + @@ansi_end}\n\n", @@type_speed)
  end

  def game_setup
    board_illustration = <<~EOF
      In case the UTF chess pieces and colours aren't clear, two letters are written after each piece.
      The first letter represents the first letter of the piece type, e.g. P = Pawn, Q = Queen.
      The second letter represents the colour, e.g. b = black, w = white.
    EOF
    sleep 0.7
    display_string("here's your board:\n", @@type_speed)
    sleep 0.7
    display_string("#{@@green}#{black_player.name}#{@@ansi_end} playing from black pieces at the top of the board.", @@type_speed)
    sleep 0.8
    board.display_board_utf
    sleep 1
    display_string("#{@@blue + white_player.name + @@ansi_end} playing from white pieces at bottom of the board.", @@type_speed)
    puts "\n"
    sleep 3
    display_string(board_illustration, @@type_speed)
    # puts "\n"
    sleep 2
  end
  
  
  def start_game
    display_string(@@turn_instructions, @@type_speed)
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
  @@turn_instructions = <<~EOF
    When prompted to take a turn please type your move by piece's current position, comma,
    position to move piece to, e.g. #{@@cyan}b1,d1#{@@ansi_end}, then key return.
  EOF

  def display_string(string, delay)
    string.each_char do |char|
      print char
      sleep(delay)
    end
    puts
  end

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

# puts Game.class_variable_get(:@@cmd_format).inspect
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
  
  game = Game.new
  # puts game.player_1.inspect
  game.game_setup
  sleep 1
  game.start_game