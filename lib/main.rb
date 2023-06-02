require_relative 'game'
game = Game.new
game.game_setup
game.play_game
  
# ___________________________________________________

# puts Game.class_variable_get(:@@cmd_format).inspect
# b = Board.new
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


# puts "active player is #{game.active_player.inspect}"
# puts "player 1 is #{game.player_1.inspect}"
# puts "white player is #{game.white_player.inspect}"
# puts '\n\n'
# game.toggle_turn
# puts "new active player is #{game.active_player.inspect}"
# puts "player 1 is #{game.player_1.inspect}"
# puts "black player is #{game.black_player.inspect}"

# game.colour_assignment
# game.game_setup
# p "#{__dir__}"
# puts game.player_1.inspect
# sleep 1

