require 'yaml'
require 'erb'
require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :player1, :player2, :active_player
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
    @player1 = Player.new(get_player1_name)
    display_string(ERB.new(yaml_data['game']['player1_greeting']).result(binding), @@type_speed)
    sleep 0.3
    @player2 = Player.new(get_player2_name)
    display_string(ERB.new(yaml_data['game']['player2_greeting']).result(binding), @@type_speed)
  end

  def play_game
    # get players names
    # randomly choose colour
    # report colour
    # populate board
    # begin game
  end
  
  def assign_colour
    display_string(yaml_data['game']['assigning_colour1'], @@type_speed)
    player1.colour = random_colour; sleep 1;
    display_string(ERB.new(yaml_data['game']['player1_colour_stmnt']).result(binding), @@type_speed)
    player1.colour == :white ? player2.colour = :black : player2.colour = :white; sleep 0.5;
    display_string(ERB.new(yaml_data['game']['player2_colour_stmnt']).result(binding), @@type_speed); sleep 0.7
  end

  def game_setup
    display_string("here's your board:\n", @@type_speed); sleep 0.7;
    display_string(ERB.new(yaml_data['game']['black_piece_instructions']).result(binding), @@type_speed); sleep 0.8;
    board.display_board_utf; sleep 1;
    display_string(ERB.new(yaml_data['game']['white_piece_instructions']).result(binding), @@type_speed)
    puts "\n"; sleep 3;
    display_string(yaml_data['game']['board_illustration'], @@type_speed)
    puts "\n"; sleep 2;
  end
  
  
  def start_game
    display_string(ERB.new(yaml_data['game']['turn_instructions']).result(binding), @@type_speed)
    # turn_instructions = yaml_data['game']['turn_instructions']
    # formatted_instructions = turn_instructions.encode('UTF-8')
    # display_string(formatted_instructions, @@type_speed)
    # puts yaml_data['game']['turn_instructions']
    
  end
  
  def starting_player
    @active_player = white_player
  end
  
  def toggle_turn
    active_player == player1 ? (self.active_player = player2) : (self.active_player = player1)
  end
  
  
  private
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

  def get_player1_name
    $stdin.gets.chomp
  end
  
  def get_player2_name
    $stdin.gets.chomp
  end
  def player1_name
    BLUE + player1.name.capitalize + ANSI_END
  end
  
  def player2_name
    GREEN + player2.name.capitalize + ANSI_END
  end
  
  def random_colour
    [:white, :black].sample
  end
  
end

