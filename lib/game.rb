require 'pry-byebug'
require 'yaml'
require 'erb'
require_relative 'board'
require_relative 'player'
require_relative 'ui_module'
require_relative '../lib/errors/input_errors'

Dir[File.join(__dir__, 'pieces', '*.rb')].each { |file| require_relative file }

class Game
  include UiModule
  attr_accessor :player1, :player2, :active_player, :active_user_move, :moves
  attr_reader :board, :taken_pieces

  def initialize
    build_board
    create_players
    assign_colour
    @active_player = white_player
    @moves = []
    @taken_pieces = []
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
    player1.colour = random_colour; sleep 0.3;
    display_string(ERB.new(yaml_data['game']['player1_colour_stmnt']).result(binding), @@type_speed)
    player1.colour == :white ? player2.colour = :black : player2.colour = :white; sleep 0.5;
    display_string(ERB.new(yaml_data['game']['player2_colour_stmnt']).result(binding), @@type_speed); sleep 0.7
  end

  def game_setup
    display_string("Here's your board:", @@type_speed); sleep 0.7;
    display_string(ERB.new(yaml_data['game']['black_piece_instructions']).result(binding), @@type_speed); sleep 0.1;
    board.display_board_utf; sleep 1;
    display_string(ERB.new(yaml_data['game']['white_piece_instructions']).result(binding), @@type_speed)
    puts "\n"; sleep 1;
    display_string(yaml_data['game']['board_illustration'], 0.005)
    puts "\n"; sleep 1;
  end
  
  def play_game
    start_game
    # until game_finished? 
    get_move
    make_move
    # end
  end

  def add_move(indexed_move)
    if index_format?(indexed_move)
      true_move?(indexed_move) ? @moves << indexed_move : (raise InputError.new("Input; #{indexed_move} does not represent an actual move"))
    else
      raise InputError.new("Indexed_move; #{indexed_move} should be formatted like 'iiii'")
    end
  end
  
  def last_move
    moves.last
  end

  def first_move?
    @first_move
  end

  def first_move_made
    @first_move = false
  end

  def make_move
    puts "here's my active player #{active_player}"
    move = moves.last
    puts "here's my move #{move}"
    moving_piece = board.grid[move[0].to_i][move[1].to_i] # Must be a piece, or move invalid, and screened for invalid move in #get_move already
    move_square = move[2] + move[3] # a 2 integer string
    move_square_occupant = board.grid[move[2].to_i][move[3].to_i] # either a Piece or nil
    
    return rescue_against_this_piece_move_rules(moving_piece, move) unless moving_piece.piece_valid_move?(move, board)
    # return rescue_against_other_piece_move_rules unless moving_piece.game_valid_move?(game, move)

    # if game_valid_move?(move)
    puts "************************************"
    puts "yes the pieces rules allow that move"
    puts "************************************"
    #   place_move(move)
    # Don't forget to set pieces' @first_move variable `piece.first_move_made` on piece to false.
    # Don't forget to set players' @first_move variable `player.first_move_made` on piece to false.
    #   toggle_turn
      # get_move
      # make_move
      
        # else
      #   puts 'you cannot make that move because xyz'
      # end
    # else
      
      # rescue_first_move_piece_error
    # end
    # check whether valid piece move
    # if so:
      # make move check for win, change active user hand turn over.
    # If not explain why not and prompt player turn again
  end

  def game_valid_move(move)
    # MOVE PATH CLEAR
    unless board.piece(move[0], move[1]).is_a(Knight)
      abort_move(move, "Your move's; #{chess_format(move)} path is not clear, try again.") unless move_path_clear?(move)
    end
    # IF IN CHECK, MOVE MUST REMOVE FROM CHECK
    if in_check?(active_player)
      place_move
      if in_check?(active_player)
        rollback_move
        abort_move(move, "Your king's in check, your move #{chess_format(move)} did not move it out of check. Take checking piece, move king, or block path. Try again.")
      end
      rollback_move
    end


    # if move_creates_own_check?(move)
    #   #abort_move with GameRuleError, "Move not allowed. This move would result in you being in check"
    # else
    #   next
    # end

    # if piece has left or right pawn neighbour && that pawn neighbour took last move as a double move,
    # then en-passant is possible

    # if #destination_square_occupied?
      # if with_own_colour?
        # #abort_move with GameRuleError, 'Destination contains your own piece'
      # else with_opponents_colour
        # if opponent in checkmate? (does each player have a @checkmate = false, until #checkmate? is true then sets @checkmate?)
          # #place_move (delete_piece && move moving piece in)
          # call #finish_game
        # elsif check?
          #  ?
        # else
          # #delete_piece(dest square) #move_piece(dest square)
          # toggle active player & call #get_move
        # end
      # end
    # else
      # #movepiece(dest square) = (move moving piece in)
      # toggle active player & call #get_move
    # end
  end

  def uncheck_possible(player)
    if in_check(player)
      players_king = board.find_pieces('king', player.colour)
      all_kings_moves = players_king.all_king_moves
      valid_moves = []
      
      all_kings_moves.each do |move|
        square = board.grid[move[0]][move[1]]
        valid_moves << square if square.nil? || (square.colour != player.colour)
      end

      valid_moves.each do |move|
        place_move(move)
        uncheckable = true if !in_check?(player)
        rollback_move(move)
        return true if uncheckable
      end
      return false
    else
      puts '#{player.name} is not in check'
    end
    
  end

  def place_move(move)
    src_x, src_y, dst_x, dst_y = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i
    dst_taken_piece = board.grid[dst_x][dst_y]
    @taken_pieces << [dst_taken_piece, move] unless dst_taken_piece.nil?
    board.grid[dst_x][dst_y] = board.grid[src_x][src_y]
    board.grid[src_x][src_y] = nil
    puts @taken_pieces.inspect
  end

  def rollback_move(move)
    src_x, src_y, dst_x, dst_y = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i
    board.grid[src_x][src_y] = board.grid[dst_x][dst_y]
    if @taken_pieces.last[1] == move # WARNING - there is the minimal possibility of a previous taken piece's move being the same as this move
      board.grid[dst_x][dst_y] = @taken_pieces.last[0]
      @taken_pieces.pop 
    else
      board.grid[dst_x][dst_y] = nil
    end
  end

  def in_check?(player)
    kings_location = board.find_pieces('king', player.colour)[0]
    puts "kings location here #{kings_location}"
    player.colour == :white ? opponent_colour = :black : opponent_colour = :white
    opponent_pieces = board.all_pieces(opponent_colour)
    opponent_pieces.each do |coord|
      piece = board.piece(coord[0], coord[1])
      all_moves_method_name = "all_#{piece.class.to_s.downcase}_moves"
      if piece.class.to_s == 'Pawn'
        return [piece, coord] if piece.send(all_moves_method_name, board).include?(kings_location)
      else
        return [piece, coord] if piece.send(all_moves_method_name).include?(kings_location)
      end
    end
    false
  end

  # def checkmate?
    # no legal move that a king can make gets it out of check
  # end

  # def stalemate?
    # !check?
    # but any legal move would result in check? being true
  # end
  
  
  private
  def abort_move(move, message)
    puts "#{message}"
    moves.pop
    get_move
  end

  def move_path_clear?(move)
    src_x, src_y, dst_x, dst_y = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i 
    
    neighbouring_squares = [[src_x+1, src_y+1], [src_x+1, src_y-1], [src_x-1, src_y-1], [src_x-1, src_y+1],
    [src_x-1, src_y],[src_x+1, src_y],[src_x, src_y-1],[src_x, src_y+1]].delete_if {|sq| sq.any? {|e| e < 0 || e > 7}} 
    return true if neighbouring_squares.include?([dst_x, dst_y])
    
    if src_x < dst_x && src_y == dst_y # down
      (src_x+1...dst_x).each { |e| return false unless board.piece(e, src_y).nil? }
    elsif src_x > dst_x && src_y == dst_y # up
      (dst_x+1...src_x).each { |e| return false unless board.piece(e, src_y).nil? }
    elsif src_x == dst_x && src_y > dst_y # left
      (dst_y+1...src_y).each { |e| return false unless board.piece(src_x, e).nil? }
    elsif src_x == dst_x && src_y < dst_y # right
      (src_y+1...dst_y).each { |e| return false unless board.piece(src_x, e).nil? }
    elsif src_x < dst_x && src_y < dst_y # down right
      (src_x+1...dst_x).zip(src_y+1...dst_y).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_x < dst_x && src_y > dst_y # down left
      (src_x+1...dst_x).zip((dst_y+1...src_y).to_a.reverse).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_x > dst_x && src_y < dst_y # up right
      (dst_x+1...src_x).to_a.reverse.zip(src_y+1...dst_y).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_x > dst_x && src_y > dst_y # up left
      (dst_x+1...src_x).zip(dst_y+1...src_y).each { |e| return false unless board.piece(e[0], e[1]).nil?  }
    end
    return true
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
  
  def random_colour
    [:white, :black].sample
  end
  
  def true_move?(move)
    move[0..1] != move[2..3]
  end
  
  def last_move
    moves.last
  end
  
  # all user input move validation done here, then move stored in Game @moves
  def get_move
    display_string(ERB.new(yaml_data['game']['move_prompt']).result(binding), @@type_speed)
    move = get_input
    return rescue_invalid_format_error(move) unless chess_format?(move)
    return rescue_untrue_move_error(move) unless true_move?(move)
    indexed_move = index_format(move)
    return rescue_empty_square_error(move) unless has_piece?(indexed_move[0].to_i, indexed_move[1].to_i)
    (return rescue_first_move_piece_error(move) unless pawn_or_knight_move?(indexed_move)) if active_player.first_move?
    add_move(indexed_move)
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
  
  def rescue_against_this_piece_move_rules(moving_piece, move)
    puts "A #{CYAN}#{moving_piece.class}#{ANSI_END} is not allowed to make the move; '#{CYAN}#{chess_format(move)}#{ANSI_END}', try again..."
    board.display_board_utf
    moves.pop
    get_move
    make_move
  end
  
  def rescue_against_other_piece_move_rules
    puts "your move #{move} is breaching the game rules because of other pieces and their relative positions, try again..."
    board.display_board_utf
    moves.pop
    get_move
    make_move
  end
  
  def has_piece?(r, c)
    board.grid[r][c] ? true : false
  end
  
  def player_start_move?
    active_player.first_move?
  end
  
  def pawn_or_knight_move?(indexed_move)
    piece = board.piece(indexed_move[0].to_i, indexed_move[1].to_i)
    piece.is_a?(Pawn) || piece.is_a?(Knight)
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
  
  def yaml_data
    yaml_file = File.join(__dir__, "data.yml")
    data = YAML.load_file(yaml_file)
  end
end

# ________ Old unused, but potentially helpful, methods _______________________

# From #move_path_clear?:
#  _______ CASE VERSION __________
  # move_direction = :down if src_x < dst_x && src_y == dst_y
  # move_direction = :up if src_x > dst_x && src_y == dst_y
  # move_direction = :left if src_x == dst_x && src_y > dst_y
  # move_direction = :right if src_x == dst_x && src_y < dst_y
  # move_direction = :down_right if src_x < dst_x && src_y < dst_y
  # move_direction = :down_left if src_x < dst_x && src_y > dst_y
  # move_direction = :up_right if src_x > dst_x && src_y < dst_y
  # move_direction = :up_left if src_x > dst_x && src_y > dst_y
  # case move_direction
  # when :down
  #   (src_x+1...dst_x).each { |e| return false unless board.piece(e, src_y).nil? }
  # when :up
  #   (dst_x+1...src_x).each { |e| return false unless board.piece(e, src_y).nil? }
  # when :left
  #   (dst_y+1...src_y).each { |e| return false unless board.piece(src_x, e).nil? }
  # when :right
  #   (src_y+1...dst_y).each { |e| return false unless board.piece(src_x, e).nil? }
  # when :down_right
  #   (src_x+1...dst_x).zip(src_y+1...dst_y).each { |e| return false unless board.piece(e[0], e[1]).nil? }
  # when :down_left
  #   (src_x+1...dst_x).zip((dst_y+1...src_y).to_a.reverse).each { |e| return false unless board.piece(e[0], e[1]).nil? }
  # when :up_right
  #   (dst_x+1...src_x).to_a.reverse.zip(src_y+1...dst_y).each { |e| return false unless board.piece(e[0], e[1]).nil? }
  # when :up_left
  #   (dst_x+1...src_x).zip(dst_y+1...src_y).each { |e| return false unless board.piece(e[0], e[1]).nil?  }
  # end
  # ________________________________


# ________ Rules ______________________________________________________________
# on start only a knight or a pawn can move