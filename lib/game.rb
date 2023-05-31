require_relative 'board'
require_relative 'player'

class Game

  def play_game
    # get players names
    # randomly choose colour
    # report colour
    # populate board
    # begin game
  end

  def setup
    puts "welcome to your new chess game playaz. Please tell me the 1st player's name?:"
    player_1_name = gets.chomp
    player_1 = Player.new(player_1_name)
    puts "hi #{player_1.name}.\nAnd player 2's name please?:"
    player_2_name = gets.chomp
    player_2 = Player.new(player_2_name)
    puts "hey there #{player_2.name}."
    puts "ok, randomly assigning a colour to you both now..."
    player_1.colour = random_colour
    puts "ok #{player_1.name}'s randomly assigned colour is #{player_1.colour}"
    player_1.colour == :white ? player_2.colour = :black : player_2.colour = :white
    puts "and #{player_2.name}'s colour therefore is #{player_2.colour}"
  end

  def random_colour
    [:white, :black].sample
  end


  b = Board.new
  # b.populate_board
  # # b.grid[1].each_with_index do |e, i|
  # #   e = Piece.new(:pawn, 1, i)
  # #   puts "#{e.y}"
  # # end
  # # b.grid[1][0] = Piece.new(:pawn, 1, 0)
  # # p = Piece.new(1,1,1)
  # # puts p.inspect
  # b.display_board_utf
  # b.display_piece(6,1)
  # b.display_piece_utf(6,1)
  # puts "heres grid[1] #{b.grid[1]}"
  # p board.inspect
  # pp "here my path; #{$:.inspect}"

end

game = Game.new
game.setup