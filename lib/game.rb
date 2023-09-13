require 'pry-byebug'
require 'yaml'
require 'erb'
require 'json'
require_relative 'board'
require_relative 'player'
require_relative 'ui_module'
require_relative 'save_and_load_module'
require_relative '../lib/errors/input_errors'

Dir[File.join(__dir__, 'pieces', '*.rb')].each { |file| require_relative file }

class Game
  include UiModule
  include SaveAndLoadModule

  attr_accessor :player1, :player2, :active_player, :active_user_move, :moves, :board, :taken_pieces, :game_finished,
                :new_game

  def initialize
    @new_game = true
    @loaded_game_name = nil
    @active_player = nil
    @moves = []
    @taken_pieces = []
    @game_finished = false
    old_or_new_game
    return unless @new_game == true
    build_board
    create_players
    assign_colour
    @active_player = white_player
  end

  #  ****************** GAME SETUP LOGIC ***********************

  def build_board
    @board = Board.new
  end

  def create_players
    display_string(yaml_data['game']['welcome'], @@type_speed)
    display_string(yaml_data['game']['player1_name_prompt'], @@type_speed)
    create_player1
    display_string(ERB.new(yaml_data['game']['player1_greeting']).result(binding), @@type_speed)
    sleep 0.3
    display_string(yaml_data['game']['player2_name_prompt'], 0.0001)
    create_player2
    display_string(ERB.new(yaml_data['game']['player2_greeting']).result(binding), @@type_speed)
  end

  def assign_colour
    display_string(yaml_data['game']['assigning_colour1'], @@type_speed)
    player1.colour = random_colour
    sleep 0.3
    display_string(ERB.new(yaml_data['game']['player1_colour_stmnt']).result(binding), @@type_speed)
    player2.colour = (player1.colour == :white ? :black : :white)
    sleep 0.4
    display_string(ERB.new(yaml_data['game']['player2_colour_stmnt']).result(binding), @@type_speed)
    sleep 0.4
  end

  def game_setup
    display_string(ERB.new(yaml_data['game']['black_piece_instructions']).result(binding), @@type_speed)
    sleep 0.1
    display_string(ERB.new(yaml_data['game']['white_piece_instructions']).result(binding), @@type_speed)
    puts "\n"
    display_string(yaml_data['game']['board_illustration'], @@type_speed)
    sleep 1.4
    puts "\n"
  end

  #  ****************** GAME PLAY LOGIC ***********************

  def play_game
    start_game
    until @game_finished == true
      get_move
      make_move unless @game_finished == true
    end
  end

  def make_move
    move = moves.last
    src, dst = move[0] + move[1], move[2] + move[3]
    src_r, src_c, dst_r, dst_c = src[0], src[1], dst[0], dst[1]
    src_piece = board.piece(src_r.to_i, src_c.to_i)

    return rescue_against_piece_move_rules(src_piece, move) unless src_piece.valid_move?(move, board)
    return rescue_against_move_self_into_check(move) if moves_into_check?(move, active_player)

    place_move(move)
    # puts "******* #{CYAN}TAKEN PIECE was;#{ANSI_END} \"#{taken_pieces.last[0].inspect}\" in DST is now;#{board.piece(move[2].to_i, move[3].to_i)}"
    active_player.first_move = false if active_player.first_move?
    src_piece.first_move = false if src_piece.first_move?
    puts "\n#{CYAN}#### #{opponent_player.inspect}#{ANSI_END} IS NOW IN CHECK\n" if in_check(opponent_player)

    if checkmate?(opponent_player)
      puts "Checkmate, #{active_player.inspect} wins, #{opponent_player.inspect} has been mated. Game over."
      @game_finished = true
      return
    elsif stalemate?(opponent_player)
      puts "Stalemate, it's a draw. Game over."
      @game_finished = true
      return
    elsif king_taken?
      puts "YAY GAME OVER #{opponent_player.inspect} WAS THE WINNER"
      @game_finished = true
      return
    end
    toggle_active_player
    sleep 0.5
  end

  def rescue_against_piece_move_rules(src_piece, move)
    puts "A #{CYAN}#{src_piece.class}#{ANSI_END} is not allowed to make the move; '#{CYAN}#{index_format_to_chess_notation(move)}#{ANSI_END}', try again..."
    moves.pop
  end

  def rescue_against_move_self_into_check(move)
    puts "your move #{CYAN}#{index_format_to_chess_notation(move)}#{ANSI_END} moves or leaves you in check, try again..."
    moves.pop
  end

  #  ****************** MOVE LOGIC ***********************

  def place_move(move)
    src_r, src_c, dst_r, dst_c = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i
    dst_taken_piece = board.grid[dst_r][dst_c]
    @taken_pieces << [dst_taken_piece, move] # if no piece in dst, still stores nil, for history logging value.
    board.grid[dst_r][dst_c] = board.grid[src_r][src_c]
    board.grid[dst_r][dst_c].r, board.grid[dst_r][dst_c].c = dst_r, dst_c
    board.grid[src_r][src_c] = nil
  end

  def reverse_move(move)
    src_r, src_c, dst_r, dst_c = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i
    board.grid[src_r][src_c] = board.grid[dst_r][dst_c]
    board.grid[src_r][src_c].r, board.grid[src_r][src_c].c = src_r, src_c

    if @taken_pieces.last[1] == move
      if @taken_pieces.last[0].nil?
        board.grid[dst_r][dst_c] = nil
      elsif !@taken_pieces.last[0].nil?
        board.grid[dst_r][dst_c] = @taken_pieces.last[0]
        board.grid[dst_r][dst_c].r, board.grid[dst_r][dst_c].c = dst_r, dst_c
      end
      @taken_pieces.pop
    else
      board.grid[dst_r][dst_c] = nil
    end
  end

  #  ****************** CHECKING LOGIC ***********************

  def in_check(player)
    kings_location = board.find_pieces('king', player.colour).flatten
    opponent_colour = player.colour == :white ? :black : :white
    opponent_pieces = board.all_pieces(opponent_colour)
    checking_pieces = []

    opponent_pieces.each do |src|
      src_r, src_c = src[0], src[1]
      piece = board.piece(src_r, src_c)
      valid_moves_method_name = "valid_#{piece.class.to_s.downcase}_moves"
      valid_moves = piece.send(valid_moves_method_name, src, board)
      checking_pieces << [piece, src] if valid_moves.include?(kings_location)
    end
    checking_pieces.empty? ? false : checking_pieces
  end

  def removes_check?(move, player)
    if in_check(player)
      place_move(move)
      if in_check(player)
        puts '**** player still in check after move placed'
        reverse_move(move)
        false
      elsif !in_check(player)
        puts "**** #{move} MOVE WILL REMOVE CHECK..."
        reverse_move(move)
        true
      end
    elsif !in_check(player)
      puts "#{player.name} was not in check in the first place"
      false
    end
  end

  def moves_into_check?(move, player)
    place_move(move)
    puts_in_check = in_check(player)
    reverse_move(move)
    puts_in_check ? true : false
  end

  def checkmate?(player)
    return false unless in_check(player)

    player_pieces = board.all_pieces(player.colour)

    player_pieces.each do |src|
      src_r, src_c = src[0], src[1]
      piece = board.piece(src_r, src_c)
      valid_moves_method_name = "valid_#{piece.class.to_s.downcase}_moves"
      piece_valid_moves = piece.send(valid_moves_method_name, src, board)

      piece_valid_moves.each do |dst|
        move = src_r.to_s + src_c.to_s + dst[0].to_s + dst[1].to_s
        return false if removes_check?(move, player)
      end
    end
    true
  end

  def stalemate?(player)
    puts 'player already in check, ∴ if no moves this would be checkmate not stalemate' if in_check(player)
    player_pieces = board.all_pieces(player.colour)
    legal_moves = []

    player_pieces.each do |src|
      src_r, src_c = src[0], src[1]
      piece = board.piece(src_r, src_c)
      valid_moves_method_name = "valid_#{piece.class.to_s.downcase}_moves"
      piece_valid_moves = piece.send(valid_moves_method_name, src, board)

      piece_valid_moves.each do |dst|
        move = src_r.to_s + src_c.to_s + dst[0].to_s + dst[1].to_s
        legal_moves << move unless moves_into_check?(move, player)
      end
    end
    # puts "**** HERES LEGAL MOVES: #{legal_moves}\n"
    legal_moves.empty? ? true : false
  end

  def king_taken?
    return true if !taken_pieces.empty? && taken_pieces.last[0].is_a?(King)
    false
  end

  private
  def first_move?
    @first_move
  end

  def create_player1
    player1_name = get_input
    while player1_name.empty?
      puts 'please enter at least one character'
      player1_name = get_input
    end
    @player1 = Player.new(player1_name)
  end

  def create_player2
    player2_name = get_input
    until player2_name != player1.name && !player2_name.empty?
      puts 'please enter at least one char, and a different name to player 1'
      player2_name = get_input
    end
    @player2 = Player.new(player2_name)
  end

  def random_colour
    %i[white black].sample
  end

  def true_move?(move)
    move[0..1] != move[3..4]
  end

  # all user input move validation done here
  def get_move
    board.display_board_utf
    display_string(ERB.new(yaml_data['game']['move_prompt']).result(binding), @@type_speed)
    move = get_input
    return save_game if move == 'save'
    return rescue_invalid_format_error(move) unless chess_notation_format?(move)
    return rescue_untrue_move_error(move) unless true_move?(move)
    indexed_move = chess_to_index_format(move)
    return rescue_empty_square_error(move) unless has_piece?(indexed_move[0].to_i, indexed_move[1].to_i)
    return rescue_unowned_piece_error(move) unless own_piece?(indexed_move)
    (return rescue_first_move_piece_error(move) unless pawn_or_knight_move?(indexed_move)) if active_player.first_move?
    add_move(indexed_move)
  end
  
  def add_move(indexed_move)
    @moves << indexed_move
  end

  def rescue_invalid_format_error(move)
    display_string(ERB.new(yaml_data['game']['invalid_format']).result(binding), @@type_speed)
    get_move
  end

  def rescue_unowned_piece_error(move)
    display_string(ERB.new(yaml_data['game']['unowned_piece']).result(binding), @@type_speed)
    get_move
  end

  def rescue_untrue_move_error(move)
    display_string(ERB.new(yaml_data['game']['untrue_move']).result(binding), @@type_speed)
    get_move
  end

  def rescue_empty_square_error(move)
    display_string(ERB.new(yaml_data['game']['empty_square']).result(binding), @@type_speed)
    get_move
  end

  def rescue_first_move_piece_error(move)
    indexed_move = chess_to_index_format(move)
    puts indexed_move
    display_string(ERB.new(yaml_data['game']['first_move_error']).result(binding), @@type_speed)
    get_move
  end

  def own_piece?(indexed_move)
    x, y = indexed_move[0].to_i, indexed_move[1].to_i
    puts "#{board.piece(x, y).inspect}"
    active_player.colour == board.piece(x, y).colour
  end

  def has_piece?(r, c)
    board.grid[r][c] ? true : false
  end

  def pawn_or_knight_move?(indexed_move)
    piece = board.piece(indexed_move[0].to_i, indexed_move[1].to_i)
    piece.is_a?(Pawn) || piece.is_a?(Knight)
  end

  def game_finished?
    @game_finished
  end

  def toggle_active_player
    active_player == player1 ? self.active_player = player2 : self.active_player = player1
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

  def opponent_player
    active_player == player1 ? player2 : player1
  end

  def yaml_data
    yaml_file = File.join(__dir__, 'data.yml')
    data = YAML.load_file(yaml_file)
  end
end