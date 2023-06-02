require 'yaml'
require 'erb'
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
    display_string(yaml_variables['game']['welcome'], 0.01)
    display_string(yaml_variables['game']['player1_name_prompt'], 0.01)
    @player_1 = Player.new(get_player1_name)
    display_string(ERB.new(yaml_variables['game']['player1_greeting']).result(binding), @@type_speed)
    sleep 0.3
    @player_2 = Player.new(get_player2_name)
    display_string(ERB.new(yaml_variables['game']['player2_greeting']).result(binding), @@type_speed)
  end

  def play_game
    # get players names
    # randomly choose colour
    # report colour
    # populate board
    # begin game
  end
  
  def assign_colour
    display_string(yaml_variables['game']['assigning_colour1'], @@type_speed)
    player_1.colour = random_colour; sleep 1;
    display_string(ERB.new(yaml_variables['game']['player1_colour_stmnt']).result(binding), @@type_speed)
    player_1.colour == :white ? player_2.colour = :black : player_2.colour = :white; sleep 0.5;
    display_string(ERB.new(yaml_variables['game']['player2_colour_stmnt']).result(binding), @@type_speed); sleep 0.7
  end

  def game_setup
    display_string("here's your board:\n", @@type_speed); sleep 0.7;
    display_string(ERB.new(yaml_variables['game']['black_piece_instructions']).result(binding), @@type_speed); sleep 0.8;
    board.display_board_utf; sleep 1;
    display_string(ERB.new(yaml_variables['game']['white_piece_instructions']).result(binding), @@type_speed)
    puts "\n"; sleep 3;
    display_string(yaml_variables['game']['board_illustration'], @@type_speed)
    puts "\n"; sleep 2;
  end
  
  
  def start_game
    display_string(ERB.new(yaml_variables['game']['turn_instructions']).result(binding), @@type_speed)
    # turn_instructions = yaml_variables['game']['turn_instructions']
    # formatted_instructions = turn_instructions.encode('UTF-8')
    # display_string(formatted_instructions, @@type_speed)
    # puts yaml_variables['game']['turn_instructions']
    
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

  def colour_emoji(colour)
    colour == :black ? "\u{26AB}" : "\u{26AA}"
  end

  def yaml_variables
    yaml_file = File.join(__dir__, "variables.yml")
    variables = YAML.load_file(yaml_file)
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
    player_1.name.capitalize
  end
  
  def player2_name
    player_2.name.capitalize
  end
  
  def random_colour
    [:white, :black].sample
  end
  
end

