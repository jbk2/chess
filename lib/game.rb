require 'yaml'
require 'erb'
require 'pry-byebug'
require_relative 'board'
require_relative 'player'
Dir[File.join(__dir__, 'pieces', '*.rb')].each { |file| require_relative file }

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
    create_player1
    display_string(ERB.new(yaml_data['game']['player1_greeting']).result(binding), @@type_speed)
    sleep 0.3
    display_string(yaml_data['game']['player2_name_prompt'], 0.01)
    create_player2
    display_string(ERB.new(yaml_data['game']['player2_greeting']).result(binding), @@type_speed)
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
  
  def play_game
    start_game
    # until game_finished? # yet to be written
    get_move
    make_move
    # end
  end

  def make_move
    puts "here's my active player #{active_player}"
    move = active_player.moves.last #only the active player's move ever attempts to be made
    puts "here's my move #{move}"
    moving_piece = board.grid[move[0].to_i][move[1].to_i] # Must be a piece, or move invalid, and screened for invalid move in #get_move already
    move_square = move[2] + move[3] # a 2 integer string
    move_square_occupant = board.grid[move[2].to_i][move[3].to_i] # either a Piece or nil

    if moving_piece.piece_valid_move?(move)
      # if game_valid_move?(move)
      puts "************************************"
      puts "yes the pieces rules allow that move"
      puts "************************************"

      #   place_move(move)
      #   toggle_turn
      # else
      #   puts 'you cannot make that move because xyz'
      # end
    else
      puts "your piece #{moving_piece} is not allowed to make the move; #{move}, try again..."
      active_player.moves.pop
      get_move
      make_move
    end
    # check whether valid piece move
    # if so:
      # make move check for win, change active user hand turn over.
    # If not explain why not and prompt player turn again
  end
  
  private
  def self.format_to_index(chess_move)
    indexed_move = String.new
    indexed_move[0] = (chess_move[0].upcase.ord - 'A'.ord).to_s
    indexed_move[1] = (chess_move[1].to_i - 1).to_s
    indexed_move[2] = (chess_move[3].upcase.ord - 'A'.ord).to_s
    indexed_move[3] = (chess_move[4].to_i - 1).to_s
    indexed_move
  end

  def self.char_to_int(char)
    char.upcase
    char.ord - 'A'.ord
  end
  
  def create_player1
    player1_name = get_input
    if player1_name == ''
      puts "please enter at least one character"
      get_player1_name
    end
    @player1 = Player.new(player1_name)
  end
  
  def create_player2
    player2_name = get_input
    if player2_name == ''
      puts "please enter at least one character"
      get_player2_name
    elsif player2_name == player1.name  
      puts "please use a different name to Player 1"
      get_player2_name
    end
    @player2 = Player.new(player2_name)
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
  
  # all user input move validation done here, then sent to active player to store in their @moves
  def get_move
    display_string(ERB.new(yaml_data['game']['move_prompt']).result(binding), @@type_speed)
    move = get_input

    return rescue_invalid_format_error(move) unless move_valid_format?(move)
    return rescue_untrue_move_error(move) unless true_move?(move)
    indexed_move = Game.format_to_index(move)
    return rescue_empty_square_error(move) unless has_piece?(indexed_move[0].to_i, indexed_move[1].to_i)
    return rescue_first_move_piece_error(move) unless pawn_or_knight_move?(indexed_move)

    active_player.add_move(indexed_move)
  end

  def rescue_invalid_format_error(move)
    puts "your move; '#{CYAN}#{move}#{ANSI_END}' was not formated correctly, it shoud be formatted like; 'a1,a2', try again..."
    get_move
  end
  
  def rescue_untrue_move_error(move)
    puts "your move; '#{CYAN}#{move}#{ANSI_END}' didn't ask your given piece to move anywhere, please enter an actual move..."
    get_move
  end
  
  def rescue_empty_square_error(move)
    puts "Square '#{CYAN}#{move}#{ANSI_END}' doesn't contain a piece. Please enter a piece's position and your move..."
    get_move
  end
  
  def rescue_first_move_piece_error(move)
    puts "Your first move can only be a Pawn or a Knight, this '#{CYAN}#{move}#{ANSI_END}' was neither, try again..."
    get_move
  end

  def move_valid_format?(move)
    move.match?(/[a-h][1-8],[a-h][1-8]/) && move.length == 5
  end

  def true_move?(move)
    move[0..1] != move[3..4]
  end

  def has_piece?(r, c)
    board.grid[r][c] ? true : false
  end

  def pawn_or_knight_move?(indexed_move)
    piece = board.piece(indexed_move[0].to_i, indexed_move[1].to_i)
    piece.is_a?(Pawn) || piece.is_a?(Knight)
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

# ________ Old unused, but potentially helpful, methods _______________________


# ________ Rules ______________________________________________________________
# on start only a knight or a pawn can move