require 'yaml'
require 'erb'
require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :player1, :player2, :active_player, :active_user_move
  attr_reader :board

  BLUE = "\e[34m"
  GREEN = "\e[32m"
  BOLD_WHITE = "\e[1;37m"
  CYAN = "\e[0;36m"
  ANSI_END = "\e[0m"
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
    display_string(yaml_data['game']['welcome'], 0.01)
    display_string(yaml_data['game']['player1_name_prompt'], 0.01)
    @player1 = Player.new(get_input)
    display_string(ERB.new(yaml_data['game']['player1_greeting']).result(binding), @@type_speed)
    sleep 0.3
    @player2 = Player.new(get_input)
    display_string(ERB.new(yaml_data['game']['player2_greeting']).result(binding), @@type_speed)
  end

  def play_game
    start_game
    get_move
    make_move
    #
  end

  def make_move
    # check whether valid move,
    # if so:
      # make move check for win, change active user hand turn over.
    # If not explain why not and prompt player turn again
  end
  
  def assign_colour
    display_string(yaml_data['game']['assigning_colour1'], @@type_speed)
    player1.colour = random_colour; sleep 1;
    display_string(ERB.new(yaml_data['game']['player1_colour_stmnt']).result(binding), @@type_speed)
    player1.colour == :white ? player2.colour = :black : player2.colour = :white; sleep 0.5;
    display_string(ERB.new(yaml_data['game']['player2_colour_stmnt']).result(binding), @@type_speed); sleep 0.7
  end

  def game_setup
    display_string("Here's your board:", @@type_speed); sleep 0.7;
    display_string(ERB.new(yaml_data['game']['black_piece_instructions']).result(binding), @@type_speed); sleep 0.8;
    board.display_board_utf; sleep 1;
    display_string(ERB.new(yaml_data['game']['white_piece_instructions']).result(binding), @@type_speed)
    puts "\n"; sleep 3;
    display_string(yaml_data['game']['board_illustration'], @@type_speed)
    puts "\n"; sleep 2;
  end
  
  
  private
  def get_player1_name
    $stdin.gets.chomp
  end
  
  def get_player2_name
    $stdin.gets.chomp
  end

  def get_input
    $stdin.gets.chomp
  end

  def random_colour
    [:white, :black].sample
  end
  
  
  def start_game
    display_string(ERB.new(yaml_data['game']['turn_instructions']).result(binding), @@type_speed)
    display_string(ERB.new(yaml_data['game']['start_prompt']).result(binding), @@type_speed)
  end
  
  def get_move
    display_string(ERB.new(yaml_data['game']['move_prompt']).result(binding), @@type_speed)
    move = get_input
    if move_valid_format?(move)
      if true_move?(move)
        active_player.add_move(move)
      else
        puts "you didn't ask your piece to move anywhere, please enter an actual move"
        get_move
      end
    else
      puts "your move; '#{CYAN}#{move}#{ANSI_END}', was not formated correctly, it shoud be formatted like; 'a1,a2', try again..."
      get_move
    end
  end

  def move_valid_format?(move)
    move.match?(/[a-h][1-8],[a-h][1-8]/)
  end

  def true_move?(move)
    move[0..1] != move[3..4]
  end
  
  def starting_player
    @active_player = white_player
  end
  
  def toggle_turn
    active_player == player1 ? (self.active_player = player2) : (self.active_player = player1)
  end
  
  def player1_name
    BLUE + player1.name.capitalize + ANSI_END
  end
  
  def player2_name
    GREEN + player2.name.capitalize + ANSI_END
  end

  def white_player
    player1.colour == :white ? player1 : player2
  end
  
  def black_player
    player1.colour == :black ? player1 : player2
  end

  def white_player_name
    player1.colour == :white ? player1_name : player2_name
  end
  
  def black_player_name
    player1.colour == :black ? player1_name : player2_name
  end  
  
  def active_player_name
    active_player == player1 ? player1_name : player2_name
  end
  
  def colour_emoji(colour)
    colour == :black ? "\u{26AB}" : "\u{26AA}"
  end

  def yaml_data
    yaml_file = File.join(__dir__, "data.yml")
    data = YAML.load_file(yaml_file)
  end

  def display_string(string, delay)
    string.each_char do |char|
      print char
      sleep(delay)
    end
    puts
  end
end

