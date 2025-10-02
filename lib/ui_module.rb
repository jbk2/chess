module UiModule
  BLUE = "\e[34m"
  GREEN = "\e[32m"
  BOLD_WHITE = "\e[1;37m"
  CYAN = "\e[0;36m"
  ANSI_END = "\e[0m"
  @@type_speed = 0.005

  def start_game
    display_string(ERB.new(yaml_data['game']['turn_instructions']).result(binding), @@type_speed); sleep 1.1;
    display_string(ERB.new(yaml_data['game']['start_prompt']).result(binding), @@type_speed); sleep 1.1;
  end

  def get_input
    $stdin.gets.chomp
  end

  def colour_emoji(colour)
    colour == :black ? "\u{26AB}" : "\u{26AA}"
  end

  def index_format?(move)
    move.match?(/[0-7][0-7][0-7][0-7]/) && move.length == 4
  end

  def index_format(chess_move)
    indexed_move = String.new
    indexed_move[0] = (chess_move[0].to_i - 1).to_s
    indexed_move[1] = (chess_move[1].upcase.ord - 'A'.ord).to_s
    indexed_move[2] = (chess_move[3].to_i - 1).to_s
    indexed_move[3] = (chess_move[4].upcase.ord - 'A'.ord).to_s
    indexed_move
  end

  def index_format_to_chess_notation(index_move)
    chess_move = String.new
    chess_move[0] = ((index_move[1].to_i) + 'A'.ord).chr.downcase 
    chess_move[1] = (((index_move[0].to_i) - 8).abs).to_s
    chess_move[2] = ','
    chess_move[3] = ((index_move[3].to_i) + 'A'.ord).chr.downcase
    chess_move[4] = (((index_move[2].to_i) - 8).abs).to_s
    chess_move
  end

  def chess_notation_format?(move)
    move.match?(/[a-h][1-8],[a-h][1-8]/) && move.length == 5
  end

  def chess_to_index_format(chess_move)
    indexed_move = String.new
    indexed_move[0] = ((chess_move[1].to_i - 8).abs).to_s
    indexed_move[1] = (chess_move[0].upcase.ord - 'A'.ord).to_s
    indexed_move[2] = ((chess_move[4].to_i - 8).abs).to_s
    indexed_move[3] = (chess_move[3].upcase.ord - 'A'.ord).to_s
    indexed_move
  end

  def display_string(string, delay)
    string.each_char do |char|
      print char
      sleep(delay)
    end
    puts
  end
end