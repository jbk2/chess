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
  # attr_writer :game_finished

  def initialize
    build_board
    create_players
    assign_colour
    @active_player = white_player
    @moves = []
    @taken_pieces = []
    @game_finished = false
  end

#  ****************** GAME SETUP LOGIC ***********************

  def build_board
    @board = Board.new
  end

  def create_players
    display_string(yaml_data['game']['welcome'], 0.0001); display_string(yaml_data['game']['player1_name_prompt'], 0.0001);
    create_player1
    display_string(ERB.new(yaml_data['game']['player1_greeting']).result(binding), @@type_speed); sleep 0.3;
    display_string(yaml_data['game']['player2_name_prompt'], 0.0001)
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
    display_string(ERB.new(yaml_data['game']['black_piece_instructions']).result(binding), @@type_speed); sleep 0.1;
    display_string(ERB.new(yaml_data['game']['white_piece_instructions']).result(binding), @@type_speed); puts "\n"; sleep 1;
    display_string(yaml_data['game']['board_illustration'], 0.005); puts "\n"; sleep 1;
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
    move = moves.last;
    src, dst = move[0] + move[1], move[2] + move[3]
    src_r, src_c, dst_r, dst_c = src[0], src[1], dst[0], dst[1]
    src_piece = board.piece(src_r.to_i, src_c.to_i)

    src_piece.valid_move?(move, board) ? (puts "** Piece rules do allow move\n") : (return rescue_against_piece_move_rules(src_piece, move))
    moves_into_check?(move, active_player) ? (return rescue_against_move_self_into_check(move)) : (puts "** Move doesn't move u into check\n")

    place_move(move)

    puts "******* #{CYAN}TAKEN PIECE was;#{ANSI_END} \"#{taken_pieces.last[0].inspect}\" in DST is now;#{board.piece(move[2].to_i, move[3].to_i)}"
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
    toggle_turn
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

# does not enforce piece or board rules, simply places the move.
  def place_move(move)
    src_r, src_c, dst_r, dst_c = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i
    dst_taken_piece = board.grid[dst_r][dst_c] # even when nil
    @taken_pieces << [dst_taken_piece, move] # when no piece in dst, still stores nil, for history logging value purposes.
    board.grid[dst_r][dst_c] = board.grid[src_r][src_c]
    board.grid[dst_r][dst_c].r = dst_r
    board.grid[dst_r][dst_c].c = dst_c
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
        board.grid[dst_r][dst_c].r = dst_r
        board.grid[dst_r][dst_c].c = dst_c
      end
      @taken_pieces.pop
    else
      board.grid[dst_r][dst_c] = nil
    end
  end

#  ****************** CHECKING LOGIC ***********************

  def in_check(player)
    kings_location = board.find_pieces('king', player.colour).flatten
    player.colour == :white ? opponent_colour = :black : opponent_colour = :white
    opponent_pieces = board.all_pieces(opponent_colour)
    checking_pieces = []
    
    opponent_pieces.each do |src|
      src_r, src_c = src[0], src[1]
      piece = board.piece(src_r, src_c)
      valid_moves_method_name = "valid_#{piece.class.to_s.downcase}_moves"
      valid_moves = piece.send(valid_moves_method_name, src, board)
      if valid_moves.include?(kings_location)
        checking_pieces << [piece, src]
      end
    end
    checking_pieces.empty? ? (return false) : (return checking_pieces)
  end

  def removes_check?(move, player)
    if in_check(player)
      place_move(move)
      if in_check(player)
        puts "**** player still in check after move placed"
        reverse_move(move)
        return false
      elsif !in_check(player)
        puts "**** #{move} MOVE WILL REMOVE CHECK..."
        reverse_move(move)
        return true
      end
    elsif !in_check(player)
      puts "#{player.name} was not in check in the first place"
      return false
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
    return true
  end

  def stalemate?(player)
    puts "player already in check, so if no moves this would be checkmate not stalemate" if in_check(player)
    player_pieces = board.all_pieces(player.colour)
    legal_moves = []
    
    player_pieces.each do |src|
      src_r, src_c = src[0], src[1]
      piece = board.piece(src_r, src_c)
      valid_moves_method_name = "valid_#{piece.class.to_s.downcase}_moves"
      piece_valid_moves = piece.send(valid_moves_method_name, src, board)

      piece_valid_moves.each do |dst|
        move = src_r.to_s + src_c.to_s + dst[0].to_s + dst[1].to_s
        legal_moves << move if !moves_into_check?(move, player)
      end
    end
    puts "**** HERES LEGAL MOVES: #{legal_moves}"
    legal_moves.empty? ? (return true) : (return false)
  end

  def king_taken?
    unless taken_pieces.empty?
      return true if taken_pieces.last[0].is_a?(King)
    end
    false
  end

  private
  def first_move?
    @first_move
  end

  def create_player1
    player1_name = get_input
    until !player1_name.empty?
      puts "please enter at least one character"
      player1_name = get_input
    end
    @player1 = Player.new(player1_name)
  end

  def create_player2
    player2_name = get_input
    until player2_name != player1.name && !player2_name.empty?
      puts "please enter at least one char, and a different name to player 1"
      player2_name = get_input
    end
    @player2 = Player.new(player2_name)
  end

  def random_colour
    [:white, :black].sample
  end

  def true_move?(move)
    move[0..1] != move[3..4]
  end

  # all user input move validation done here, then move stored in Game @moves
  def get_move
    board.display_board_utf;
    display_string(ERB.new(yaml_data['game']['move_prompt']).result(binding), @@type_speed)
    move = get_input
    return save_game if move == 'save'
    return rescue_invalid_format_error(move) unless chess_notation_format?(move)
    return rescue_untrue_move_error(move) unless true_move?(move)
    indexed_move = chess_notation_to_index_format(move)
    return rescue_empty_square_error(move) unless has_piece?(indexed_move[0].to_i, indexed_move[1].to_i)
    return rescue_unowned_piece_error(move) unless own_piece?(indexed_move)
    (return rescue_first_move_piece_error(move) unless pawn_or_knight_move?(indexed_move)) if active_player.first_move?
    add_move(indexed_move)
  end

  def add_move(indexed_move)
    if index_format?(indexed_move)
      true_move?(indexed_move) ? @moves << indexed_move : (raise InputError.new("Input; #{indexed_move} does not represent an actual move"))
    else
      raise InputError.new("Indexed_move; #{indexed_move} should be formatted like 'iiii'")
    end
  end

  def save_game
    puts self.inspect
    puts player1.inspect
    puts player2.inspect
    @game_finished = true
    puts @game_finished
    # serialize and save to file; Game, Board, Player
    # set @game_finished to true
    # output message confirming successful save, file name, and end of game
    # check that game actually ends
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
    indexed_move = chess_notation_to_index_format(move)
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

  def opponent_player
    active_player == player1 ? player2 : player1
  end
  
  def yaml_data
    yaml_file = File.join(__dir__, "data.yml")
    data = YAML.load_file(yaml_file)
  end
end

# ________ Redundant code  _______________________

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

 # def game_valid_move(move)
  #   # MOVE PATH CLEAR
  #   unless board.piece(move[0], move[1]).is_a(Knight)
  #     abort_move(move, "Your move's; #{chess_format(move)} path is not clear, try again.") unless move_path_clear?(move)
  #   end
  #   # IF IN CHECK, MOVE MUST REMOVE FROM CHECK
  #   if in_check(active_player)
  #     place_move
  #     if in_check(active_player)
  #       rollback_move
  #       abort_move(move, "Your king's in check, your move #{chess_format(move)} did not move it out of check. Take checking piece, move king, or block path. Try again.")
  #     end
  #     rollback_move
  #   end


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
  # end

    # def last_move
  #   moves.last
  # end

  # def player_start_move?
  #   active_player.first_move?
  # end

  # def king_uncheck_move_possible?(player, board)
  #   if in_check(player)
  #     king_src = board.find_pieces('king', player.colour).flatten
  #     kings_moves = board.piece(king_src[0], king_src[1]).valid_king_moves(king_src, board)

  #     kings_moves.each do |dst|
  #       move = king_src[0].to_s + king_src[1].to_s + dst[0].to_s + dst[1].to_s
  #       place_move(move)
  #       if !in_check(player)
  #         puts "********** MOVE REMOVED KING FROM CHECK"
  #         uncheck_possible = true
  #         puts "uncheck_possible is set to #{uncheck_possible.inspect}"
  #         reverse_move(move)
  #         return true if uncheck_possible
  #       end
  #       puts " ********* MOVE DOES NOT MOVE KING OUT OF CHECK ******"
  #       reverse_move(move)
  #     end
  #     return false
  #   else
  #     puts "#{player.name} is not in check in the first place"
  #   end
  # end


# ________ Rules ______________________________________________________________
# on start only a knight or a pawn can move