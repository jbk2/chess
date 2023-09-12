require_relative 'game'
# require_relative 'player'
require_relative 'ui_module'

module SaveAndLoadModule
include UiModule
  
  def to_json_data
    {
      'board' => @board.to_json_data,
      'player1' => @player1.to_json_data,
      'player2' => @player2.to_json_data,
      'active_player' => @active_player.to_json_data,
      'new_game' => @new_game,
      'loaded_game_name' => @loaded_game_name,
      'moves' => @moves,
      'taken_pieces' => @taken_pieces,
      'game_finished' => @game_finished
    }
  end
  
  def save_game
    toggle_active_player
    serialized_game = JSON.dump(self.to_json_data)
    puts "this is JSON; #{serialized_game}"
    file_name = "#{player1.name[0] + player2.name[0]}s_game_no_#{file_count + 1}.json"
    puts file_name
    save_file(file_name, serialized_game)
    @game_finished = true
    puts "is @game_finished?; #{@game_finished}"
    # output message confirming successful save, file name, and end of game
    # check that game actually ends
  end

  def file_count
    Dir['games/*'].length
  end

  def save_file(file_name, content)
    Dir.mkdir('games') unless Dir.exist?('games')
    path_name = "games/#{file_name}"
    File.open(path_name, 'w') do |file|
      file.puts(content)
    end
    puts 'file saved'
  end

  def old_or_new_game
    display_string(ERB.new(yaml_data['game']['old_or_new_game']).result(binding), @@type_speed)
    if get_input == 'load'
      @new_game = false
      list_saved_games
      load_which_game
      load_game(@loaded_game_name)
    end
  end

  def list_saved_games
    games = Dir['games/*']
    games.each_with_index do |e, i|
      puts "#{i + 1} - #{e}"
    end
  end

  def load_which_game
    display_string(ERB.new(yaml_data['game']['load_which_game']).result(binding), @@type_speed)
    game_choice = get_input
    @loaded_game_name = Dir['games/*'][(game_choice.to_i - 1)]
  end

  def load_game(game_path)
    begin 
      game_content = File.read(game_path)
      game_data = JSON.parse(game_content)
      self.from_json_data(game_data)
    rescue StandardError => e
      puts "Error loading game: #{e.message}"
    end
  end

  def from_json_data(data)
    puts data.inspect
    self.board = Board.new
    self.board.grid = board.deserialize_grid(data)
    self.player1 = Player.from_json_data(data['player1'])
    self.player2 = Player.from_json_data(data['player2'])
    self.active_player = player1.name == data['active_player']['name'] ? player1 : player2
    puts "WHITE ::::::: #{self.white_player_name}"
    puts "BLACK ::::::: #{self.black_player_name}"
    puts "PLAYER 1 NAME::: #{self.player1_name}"
    puts "PLAYER 2 NAME::: #{self.player2_name}"
    puts "PLAYER 1::: #{self.player1.inspect}"
    puts "PLAYER 2::: #{self.player2.inspect}"
    self.moves = data['moves']
    self.taken_pieces = data['taken_pieces']
    self.game_finished = data['game_finished']
    # puts "WHITE ::::::: #{self.white_player}"
    # puts "BLACK ::::::: #{self.black_player}"
    puts self.inspect
  end

end