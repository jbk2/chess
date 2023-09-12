require_relative 'game'
# require_relative 'player'
require_relative 'ui_module'

module SaveAndLoadModule
include UiModule

  def save_game
    serialized_game = JSON.dump(self.to_json_data)
    file_name = "#{player1.name[0] + player2.name[0]}s_game_no_#{file_count + 1}.json"
    save_file(file_name, serialized_game)
    @game_finished = true
    puts "is @game_finished?; #{@game_finished}"
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
    display_string(ERB.new(yaml_data['game']['game_saved']).result(binding), @@type_speed)
  end
  
  def old_or_new_game
    display_string(ERB.new(yaml_data['game']['old_or_new_game']).result(binding), @@type_speed)
    if get_input == 'load'
      list_saved_games
      load_which_game
      load_game(@loaded_game_name)
      puts "\n **** READY TO PLAY **** \n"
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
      display_string(ERB.new(yaml_data['game']['game_loaded']).result(binding), @@type_speed)
    rescue StandardError => e
      puts "Error loading game: #{e.message}"
    end
  end
  
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

  def from_json_data(data)
    self.board = Board.new
    self.board.grid = board.deserialize_grid(data)
    self.player1 = Player.from_json_data(data['player1'])
    self.player2 = Player.from_json_data(data['player2'])
    self.active_player = player1.name == data['active_player']['name'] ? player1 : player2
    self.new_game = false
    self.moves = data['moves']
    self.taken_pieces = data['taken_pieces']
    self.game_finished = data['game_finished']
  end

end