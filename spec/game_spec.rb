require_relative '../lib/game'
require_relative '../lib/ui_module'

describe Game do
  let(:game) {Game.new}
  before do
    allow($stdin).to receive(:gets).and_return("new game pls", "John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep) # stubs #sleep on Game so tests don't slow
    allow_any_instance_of(Board).to receive(:sleep) # stubs #sleep on Board so tests don't slow
  end
  
  it 'received sleep' do
    expect(game).to have_received(:sleep).at_least(:once)
  end

  describe 'instantiation' do
    it 'has a board' do
      expect(game.board).to be_instance_of(Board)
    end

    it 'has a player1' do
      expect(game.player1).to be_instance_of(Player)
    end
    
    it 'has a player2' do
      expect(game.player2).to be_instance_of(Player)
    end
    
    it 'has a readable @moves variable' do
      expect(game.moves).to eq([])
    end
    
    it 'has an @active_player, set before any moves are taken to the white player' do
      expect(game.active_player).to eq(game.send(:white_player))
    end
  end

  describe "#assign_colour" do
    it "should assign a colour to each player" do
      expect([:white, :black]).to include(game.player1.colour)
      expect([:white, :black]).to include(game.player2.colour)
    end
  end
  
  describe "@active_player" do
    it 'starts as the white player' do
      orig_active_player = game.active_player
      expect(game.active_player).to eq(game.send(:white_player))
    end

    describe "#toggle_active_player" do
      it "should change the game.active_player" do
        orig_active_player = game.active_player
        expect(game.active_player).to eq(orig_active_player)
        game.send(:toggle_active_player)
        expect(game.active_player).not_to eq(orig_active_player)
      end
    end
    
    describe "#opponent_player" do
      it 'always returns the opponent of the active player' do
        expect(game.send(:opponent_player)).to be(game.send(:black_player))
      end
    
      it 'always returns the opponent of the active player, even after #toggle_active_player' do
        game.send(:toggle_active_player)
        expect(game.send(:opponent_player)).to be(game.send(:white_player))
      end
    end
  end

  describe '#add_move(move)' do
    it 'pushes a the move string onto the @moves array' do
      game.send(:add_move, '1011')
      expect(game.moves).to eq(['1011'])
    end
  end

  describe '#get_move' do
    let(:active_player) { double(Player) }
    
    context 'when move is valid' do
      it "saves the move in the Game @moves array" do
        allow(game).to receive(:get_input).and_return('a2,a3') # Pawn
        allow(game).to receive(:moves).and_return(['6050'])
        expect(game).to receive(:add_move).with('6050')
        game.send(:get_move)
        expect(game.moves.last).to eq('6050')
      end
    end

    context 'when the move is invalid' do
      it "will not save move when formatted incorrectly" do
        allow(game).to receive(:get_input).and_return('aaa1,asdff2', 'a2,a3') # Nil, Pawn
        expect(game).not_to receive(:add_move).with('0001111001001')
        expect(game).to receive(:add_move).with('6050')
        game.send(:get_move)
      end
     
      it "will not save move when moving piece was not owned by active player" do
        allow(game).to receive(:get_input).and_return('a7,a6', 'a2,a3') # Pawn, Pawn
        # allow(game).to receive(:own_piece?).and_return(false, true)
        # expect(game).not_to receive(:add_move).with('1020')
        # expect(game).to receive(:add_move).with('6050')
        game.send(:get_move)
        expect(game.moves.include?('1020')).to be(false)
        expect(game.moves.last).to eq('6050')
      end
      
      it "will not save move when it's not a genuine move from one square to another" do
        allow(game).to receive(:get_input).and_return('a2,a2', 'a2,a3') # Pawn & Pawn
        allow(game).to receive(:true_move?).and_return(false, true)
        game.send(:get_move)
        expect(game.moves.include?('1010')).to be(false)
        expect(game.moves.last).to eq('6050')
      end
    end

    context "on a player's first move" do
      context "it won't save" do
        it "a Rook move" do
          allow(game).to receive(:get_input).and_return('a1,a3', 'b1,c3') #Rook & Knight 
          expect(game).not_to receive(:add_move).with('7050')
          expect(game).to receive(:add_move).with('7152')
          game.send(:get_move)
        end

        it "a Bishop move" do
          game.send(:toggle_active_player)
          allow(game).to receive(:get_input).and_return('c8,e6','b8,c6') #Bishop & Knight
          expect(game).not_to receive(:add_move).with('0224')
          expect(game).to receive(:add_move).with('0122')
          game.send(:get_move)
        end
        it "a Queen move" do
          game.send(:toggle_active_player)
          allow(game).to receive(:get_input).and_return('d8,f6', 'a7,a6') #Queen & Pawn
          expect(game).not_to receive(:add_move).with('0325') 
          expect(game).to receive(:add_move).with('1020')
          game.send(:get_move)
        end
        it "a King move" do
          game.send(:toggle_active_player)
          allow(game).to receive(:get_input).and_return('e8,e7','b7,b6') #King & Pawn 
          expect(game).not_to receive(:add_move).with('0414') 
          expect(game).to receive(:add_move).with('1121')
          game.send(:get_move)
        end
      end
      
      context "it will save" do
        it "will save a Pawn move" do
          game.send(:toggle_active_player)
          allow(game).to receive(:get_input).and_return('b7,b6') #Pawn
          expect(game).to receive(:add_move).with('1121')
          game.send(:get_move)
        end
        it "will save a Knight move" do
          game.send(:toggle_active_player)
          allow(game).to receive(:get_input).and_return('b8,c6') #Knight 
          expect(game).to receive(:add_move).with('0122')
          game.send(:get_move)
        end
      end
    end
  end

  describe '#pawn_or_knight_move?(move)' do
    context 'will return false' do
      it 'with a Rook' do
        result = game.send(:pawn_or_knight_move?, '0011')
        expect(result).to be(false)
      end
      it 'with a Bishop' do
        result = game.send(:pawn_or_knight_move?, '0213')
        expect(result).to be(false)
      end
      it 'with a Queen' do
        result = game.send(:pawn_or_knight_move?, '0314')
        expect(result).to be(false)
      end
      it 'with a King' do
        result = game.send(:pawn_or_knight_move?, '0415')
        expect(result).to be(false)
      end
    end
    context 'will return true' do
      it 'with a Pawn' do
        result = game.send(:pawn_or_knight_move?, '1020')
        expect(result).to be(true)
      end
      it 'with a Knight' do
        result = game.send(:pawn_or_knight_move?, '0122')
        expect(result).to be(true)
      end
    end
  end

  describe '#has_piece?(square)' do
    context 'with an actual piece in the given square' do
      it 'returns true' do
        expect(game.send(:has_piece?, 0, 0)).to be(true)
      end
    end  
    
    context 'without an actual piece/with nil in the given square' do
      it 'returns false' do
        expect(game.send(:has_piece?, 2, 0)).to be(false)
      end
    end 
  end

  # describe '#make_move' do
  #   let(:active_player) { instance_double(Player) }
  #   let(:board) { double('Board') }
  #   let(:pawn_move_piece) { instance_double(Pawn)}
  #   let(:rook_move_piece) { instance_double(Rook)}
  #   let(:knight_move_piece) { instance_double(Knight)}
  #   let(:bishop_move_piece) { instance_double(Bishop)}
  #   let(:queen_move_piece) { instance_double(Queen)}
  #   let(:king_move_piece) { instance_double(King)}
    
  #   before do
  #     allow_any_instance_of(Game).to receive(:sleep).at_least(:once)
  #     allow(game).to receive(:active_player).and_return(active_player)
  #     allow(game).to receive(:board).and_return(board) 
  #     @grid = [[rook_move_piece, knight_move_piece, bishop_move_piece, queen_move_piece, king_move_piece, bishop_move_piece, knight_move_piece, rook_move_piece],
  #     [pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece],
  #     [nil, nil, nil, nil, nil, nil, nil, nil],
  #     [nil, nil, nil, nil, nil, nil, nil, nil],
  #     [nil, nil, nil, nil, nil, nil, nil, nil],
  #     [nil, nil, nil, nil, nil, nil, nil, nil],
  #     [pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece],
  #     [rook_move_piece, knight_move_piece, bishop_move_piece, queen_move_piece, king_move_piece, bishop_move_piece, knight_move_piece, rook_move_piece]
  #     ]
  #   end
    
  #   context 'with a valid Pawn move' do
  #     it "calls the Pawn's #piece_valid_move?" do
  #       moves = ['1020']
  #       allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
  #       allow(active_player).to receive(:moves).and_return(moves)
  #       allow(board).to receive(:grid).and_return(@grid)
  #       expect(pawn_move_piece).to receive(:piece_valid_move?).with('1020')
  #       game.make_move
  #     end
  #   end

    # context 'with a valid Rook move' do
    #   it "calls Rooks#piece_valid_move?" do
    #     moves = ['0001']
    #     allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
    #     allow(active_player).to receive(:moves).and_return(moves)
    #     allow(board).to receive(:grid).and_return(@grid)
    #     expect(rook_move_piece).to receive(:piece_valid_move?).with('0001')
    #     game.make_move
    #   end
    # end
 
    # allow(game).to receive(:active_player).and_return(active_player)
    # allow(game).to receive(:move_valid_format?).and_return(true, true) #
    # allow(game).to receive(:true_move?).and_return(true, true) #
    # allow(active_player).to receive(:moves).and_return([])
    # allow(game).to receive(:pawn_or_knight_move?).and_return(false, true) #
    # allow(game).to receive(:get_input).and_return('a1,c1', 'a2,c3') #Rook & Knight 
    # expect(active_player).not_to receive(:add_move).with('0020') 
    # expect(active_player).to receive(:add_move).with('0122')
    # game.send(:get_move)

    # context 'with a valid Knight move' do
    #   it "calls Knight#piece_valid_move?" do
    #     moves = ['0122']
    #     allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
    #     allow(active_player).to receive(:moves).and_return(moves)
    #     allow(board).to receive(:grid).and_return(@grid)

    #     expect(knight_move_piece).to receive(:piece_valid_move?).with('0122')
    #     game.make_move
    #   end
    # end

    # context 'with a valid Bishop move' do
    #   it "calls Bishop#piece_valid_move?" do
    #     moves = ['0213']
    #     allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
    #     allow(active_player).to receive(:moves).and_return(moves)
    #     allow(board).to receive(:grid).and_return(@grid)
    #     expect(bishop_move_piece).to receive(:piece_valid_move?).with('0213')
    #     game.make_move
    #   end
    # end

    # context 'with a valid Queen move' do
    #   it "calls Queen#piece_valid_move?" do
    #     moves = ['7351']
    #     allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
    #     allow(active_player).to receive(:moves).and_return(moves)
    #     allow(board).to receive(:grid).and_return(@grid)
    #     expect(queen_move_piece).to receive(:piece_valid_move?).with('7351')
    #     game.make_move
    #   end
    # end

    # context 'with a valid King move' do
    #   it "calls King#piece_valid_move?" do
    #     moves = ['7463']
    #     allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
    #     allow(active_player).to receive(:moves).and_return(moves)
    #     allow(board).to receive(:grid).and_return(@grid)
    #     expect(king_move_piece).to receive(:piece_valid_move?).with('7463')
    #     game.make_move
    #   end
    # end

      # it "changes the piece's position" do
      # end
    
    # context 'with an invalid move' do
      # it "does not change the piece's position" do
      # end
    # end
  # end

  describe '#game_valid_move?' do
  end

  # describe 'only the active player can make a move' do
  # end
  # describe 'is in check?' do
  # end

  describe '#in_check(player)' do
    context 'when given player is not in check' do
      it 'returns false' do
        result = game.in_check(game.active_player)
        expect(result).to be(false)
      end
      
      it 'returns false' do
        game.board.grid[6][4] = nil
        game.board.grid[5][4] = Rook.new(:white, 5, 4)
        result = game.in_check(game.active_player)
        expect(result).to be(false)
      end
      
      it 'returns false' do
        game.send(:toggle_active_player)
        game.board.grid[1][4] = Pawn.new(:white, 1, 4)
        result = game.in_check(game.active_player)
        expect(result).to be(false)
      end
    end
    
    context 'when given player is in check' do
      it 'returns the checking piece' do
        game.board.grid[6][4] = nil
        game.board.grid[5][4] = Rook.new(:black, 5, 4)
        result = game.in_check(game.active_player)
        expect(result[0][0]).to be_a(Rook)
        expect(result[0][1]).to eq([5, 4])
      end
      
      it 'returns the checking piece' do
        game.board.grid[6][4] = nil
        game.board.grid[6][5] = nil
        game.board.grid[4][7] = Bishop.new(:black, 4, 7)
        result = game.in_check(game.active_player)
        expect(result[0][0]).to be_a(Bishop)
        expect(result[0][1]).to eq([4, 7])
      end
      
      it 'returns the checking piece' do
        game.board.grid[7][4] = nil
        game.board.grid[5][4] = King.new(:white, 5, 4)
        game.board.grid[1][0] = Bishop.new(:black, 1, 0)
        result = game.in_check(game.active_player)
        expect(result[0][0]).to be_a(Bishop)
        expect(result[0][1]).to eq([1, 0])
      end
      
      it 'returns the checking piece' do
        game.board.grid[7][4] = nil
        game.board.grid[5][4] = King.new(:white, 5, 4)
        game.board.grid[4][3] = Pawn.new(:black, 4, 3)
        result = game.in_check(game.active_player)
        expect(result[0][0]).to be_a(Pawn)
        expect(result[0][1]).to eq([4, 3])
      end
      
      it 'returns the checking piece' do
        game.board.grid[1][3] = Pawn.new(:white, 1, 3)
        game.send(:toggle_active_player)
        result = game.in_check(game.active_player)
        expect(result[0][0]).to be_a(Pawn)
        expect(result[0][1]).to eq([1, 3])
      end
    end

    context 'when given player is in check from two pieces' do
      it 'returns the two checking pieces' do
        game.board.grid[6][4] = nil
        game.board.grid[5][4] = Rook.new(:black, 5, 4)
        game.board.grid[6][6] = Knight.new(:black, 6, 6)
        result = game.in_check(game.active_player)
        expect(result.length).to equal(2)
        expect(result[0][0]).to be_a(Rook)
        expect(result[0][1]).to eq([5, 4])
        expect(result[1][0]).to be_a(Knight)
        expect(result[1][1]).to eq([6, 6])
      end
    end
  end

  describe '#moves_into_check?(move, player)' do
    it "returns true when King moves into a Rook's path" do
      game.board.grid[6][4], game.board.grid[7][4], game.board.grid[1][0] = nil, nil, nil
      game.board.grid[3][1] = King.new(:white, 3, 1)
      result = game.moves_into_check?('3130', game.active_player)
      expect(result).to be(true)
    end
    
    it "returns true when King moves into a Pawn's path" do
      game.board.grid[7][4] = nil
      game.board.grid[3][4] = King.new(:white, 3, 4)
      result = game.moves_into_check?('3424', game.active_player)
      expect(result).to be(true)
    end
   
    it "returns true when King moves into a Knight's path" do
      game.board.grid[7][4] = nil
      game.board.grid[3][5] = King.new(:white, 3, 5)
      result = game.moves_into_check?('3525', game.active_player)
      expect(result).to be(true)
    end
    
    it 'returns false when a move does not place player in check' do
      game.board.grid[6][4], game.board.grid[7][4], game.board.grid[1][0] = nil, nil, nil
      game.board.grid[3][1] = King.new(:white, 3, 1)
      result = game.moves_into_check?('3141', game.active_player)
      expect(result).to be(false)
    end
    
    it 'returns false when a move does not place player in check' do
      game.board.grid[7][4] = nil
      game.board.grid[4][5] = King.new(:white, 4, 5)
      result = game.moves_into_check?('4535', game.active_player)
      expect(result).to be(false)
    end
  end

  describe '#removes_check?(move)' do
    context 'when in check' do
      it 'returns true if move takes player out of check' do
        game.board.grid[6][4] = nil
        game.board.grid[7][3] = nil
        game.board.grid[0][3] = nil
        game.board.grid[5][4] = Rook.new(:black, 5, 4)
        move = '7473'
        result = game.removes_check?(move, game.send(:white_player))
        expect(result).to be(true)
      end
      
      it 'returns false if move does not take player out of check' do
        game.board.grid[6][4] = nil
        game.board.grid[6][3] = nil
        game.board.grid[7][3] = nil
        # game.board.grid[0][3] = nil
        game.board.grid[5][4] = Rook.new(:black, 5, 4)
        move = '7464'
        allow(game).to receive(:get_move).and_return('7473')
        result = game.removes_check?(move, game.send(:white_player))
        expect(result).to be(false)
      end
    end
    
    context 'when not check' do
      it "returns false as move doesn't move out of check as it wasn't in check in first place!" do
        game.board.grid[7][3] = nil
        # game.board.grid[0][3] = nil
        move = '7473'
        result = game.removes_check?(move, game.send(:white_player))
        expect(result).to be(false)
      end
    end
  end

  describe '#place_move(move)' do # this does not enforce piece or board move rules, it simply places move
    context 'with no piece taking' do
      it 'moves piece from src to dst square' do
        move = '1020'
        expect(game.board.grid[2][0]).to be_nil
        game.place_move(move)
        expect(game.board.grid[2][0]).to be_a(Pawn)
        expect(game.board.grid[1][0]).to be_nil
        expect(game.taken_pieces.last[0]).to be_nil
        expect(game.taken_pieces.last[1]).to eq(move)
      end
      
      it "when a move is made the piece's r & c values are updated" do
        move = '1020'
        expect(game.board.grid[2][0]).to be_nil
        game.place_move(move)
        expect(game.board.grid[2][0].r).to eq(2)
        expect(game.board.grid[2][0].c).to eq(0)
      end
    end
    
    context 'with piece taking' do # this does not enforce piece or board move rules, it simply places move
      it 'moves piece from src to dst & taken piece into @taken_pieces with record of taking move' do
        move = '1021'
        game.board.grid[2][1] = Rook.new(:white, 2, 1)
        expect(game.board.grid[2][1]).to be_a(Rook)
        expect(game.board.grid[1][0]).to be_a(Pawn)
        game.place_move(move)
        expect(game.board.grid[2][1]).to be_a(Pawn)
        expect(game.board.grid[1][0]).to be_nil
        expect(game.taken_pieces.last[0]).to be_a(Rook)
        expect(game.taken_pieces.last[1]).to eq(move)
      end
      
      it "when a move is made the piece's r & c values are updated" do
        move = '1021'
        game.board.grid[2][1] = Rook.new(:white, 2, 1)
        game.place_move(move)
        expect(game.board.grid[2][1].r).to eq(2)
        expect(game.board.grid[2][1].c).to eq(1)
      end
    end
  end

  describe '#reverse_move(move)' do
    context 'without a taken piece on last move' do
      it 'reverses back the last move' do
        move = '1021'
        game.board.grid[2][1] = nil
        game.place_move(move)
        expect(game.board.grid[2][1]).to be_a(Pawn)
        expect(game.board.grid[1][0]).to be_nil
        expect(game.taken_pieces.last[0]).to be_nil
        expect(game.taken_pieces.last[1]).to eq(move)
        game.reverse_move(move)
        expect(game.board.grid[1][0]).to be_a(Pawn)
        expect(game.board.grid[2][1]).to be_nil
      end
 
      it "updates piece with correct r & c values" do
        move = '1020'
        game.board.grid[2][0] = nil
        game.place_move(move)
        puts "here's 20 now; #{game.board.grid[2][0].inspect}"
        game.reverse_move(move)
        expect(game.board.grid[1][0].r).to eq(1)
        expect(game.board.grid[1][0].c).to eq(0)
        puts "here's 20 now; #{game.board.grid[2][0].inspect}"
        expect(game.board.grid[2][0]).to be_nil
      end
      
      it "adds array object to game's @taken_pieces with nil and the move values" do
        move = '1021'
        game.place_move(move)
        expect(game.taken_pieces.last[0]).to be_nil
        expect(game.taken_pieces.last[1]).to eq(move)
        game.reverse_move(move)
        expect(game.taken_pieces).to be_empty
      end
    end
    
    context 'with a taken piece on last move' do
      it "correctly moves taken piece to original pre-move position" do
        move = '1021'
        game.board.grid[2][1] = Rook.new(:white, 2, 0)
        game.place_move(move)
        expect(game.board.grid[2][1]).to be_a(Pawn)
        expect(game.board.grid[1][0]).to be_nil
        expect(game.taken_pieces.last[0]).to be_a(Rook)
        expect(game.taken_pieces.last[1]).to eq(move)
        game.reverse_move(move)
        expect(game.board.grid[1][0]).to be_a(Pawn)
        expect(game.board.grid[2][1]).to be_a(Rook)
        expect(game.taken_pieces.last).to satisfy { |piece| !piece.is_a?(Rook) }
      end

      it 'updates piece with correct r & c values' do
        move = '1021'
        game.board.grid[2][1] = Rook.new(:white, 2, 0)
        game.place_move(move)
        game.reverse_move(move)
        expect(game.board.grid[1][0].r).to eq(1)
        expect(game.board.grid[1][0].c).to eq(0)
        expect(game.board.grid[2][1].r).to eq(2)
        expect(game.board.grid[2][1].c).to eq(1)
      end

      it "removes previously taken piece from game's @taken_pieces array" do
        move = '1021'
        game.board.grid[2][1] = Rook.new(:white, 2, 0)
        game.place_move(move)
        game.reverse_move(move)
        expect(game.taken_pieces).to be_empty
      end
    end
  end

  def empty_board(game)
    game.board.grid.map! { Array.new(8) }
  end

  describe "#checkmate?(player)" do
    context 'when player is in check and check mate' do
      it 'will return true' do
        empty_board(game)
        game.board.grid[0][4], game.board.grid[0][7], game.board.grid[2][7] = Rook.new(:white, 0, 4), King.new(:black, 0, 7), King.new(:white, 2, 7)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(true)
      end
      
      it "will return true with 'epaulette' mate pattern" do
        empty_board(game)
        game.board.grid[0][3], game.board.grid[0][4], game.board.grid[0][5] = Rook.new(:black, 0, 3), King.new(:black, 0, 4), Rook.new(:black, 0, 5)
        game.board.grid[2][4] = Queen.new(:white, 2, 4)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(true)
      end
     
      it "will return true with 'Cozio' mate pattern" do
        empty_board(game)
        game.board.grid[3][6], game.board.grid[4][5], game.board.grid[4][6] = Pawn.new(:black, 3, 6), Queen.new(:black, 4, 5), King.new(:black, 4, 6)
        game.board.grid[5][7], game.board.grid[6][6] = Queen.new(:white, 5, 7), King.new(:white, 6, 6)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(true)
      end
     
      it "will return true with 'kill box' type mate pattern" do
        empty_board(game)
        game.board.grid[0][6] = King.new(:black, 0, 6)
        game.board.grid[0][7], game.board.grid[2][5] = Rook.new(:white, 0, 7), Queen.new(:white, 2, 5)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(true)
      end
      
      it "will return true with 'triangle' type mate pattern" do
        empty_board(game)
        game.board.grid[0][6] = King.new(:black, 0, 6)
        game.board.grid[1][5], game.board.grid[1][7] = Queen.new(:white, 1, 5), Rook.new(:white, 1, 7)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(true)
      end
    end
    
    context 'when player is in check but not check mate' do
      it 'will return false' do
        empty_board(game)
        game.board.grid[0][4], game.board.grid[1][7], game.board.grid[2][5] = Rook.new(:white, 0, 4), King.new(:black, 1, 7), King.new(:white, 2, 5)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(false)
      end

      it "will return false" do
        empty_board(game)
        game.board.grid[0][3], game.board.grid[0][4], game.board.grid[0][5] = Rook.new(:black, 0, 3), King.new(:black, 0, 4), Rook.new(:black, 0, 5)
        game.board.grid[2][3] = Knight.new(:white, 2, 3)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(false)
      end

      it "will return false with not quite a 'Cozio' check type pattern" do
        empty_board(game)
        game.board.grid[3][6], game.board.grid[4][5], game.board.grid[4][6] = Pawn.new(:black, 3, 6), Queen.new(:black, 4, 5), King.new(:black, 4, 6)
        game.board.grid[5][6] = Queen.new(:white, 5, 6)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(false)
      end

      it "will return false with close to but not a 'kill box' type check pattern" do
        empty_board(game)
        game.board.grid[0][6] = King.new(:black, 0, 6)
        game.board.grid[0][7], game.board.grid[2][4] = Rook.new(:white, 0, 7), Queen.new(:white, 2, 4)
        result = game.checkmate?(game.send(:black_player))
        expect(result).to be(false)
      end
    end
  end

  describe "#stalemate?(player)" do
    context "when player is in stalemate" do
      it "returns true" do
        empty_board(game)
        game.board.grid[7][0], game.board.grid[6][1], game.board.grid[5][2] = King.new(:black, 7, 0), Rook.new(:white, 6, 1), King.new(:white, 5, 2)
        result = game.stalemate?(game.send(:black_player))
        expect(result).to be(true)
      end
 
      it "returns true" do
        empty_board(game)
        game.board.grid[0][7], game.board.grid[2][6], game.board.grid[2][7] = King.new(:black, 0, 7), Rook.new(:white, 2, 6), King.new(:white, 2, 7)
        result = game.stalemate?(game.send(:black_player))
        expect(result).to be(true)
      end
    end

    context "when player is not in stalemate" do
      it "returns false" do
        empty_board(game)
        game.board.grid[6][0], game.board.grid[6][1], game.board.grid[5][2] = King.new(:black, 6, 0), Rook.new(:white, 6, 1), King.new(:white, 5, 2)
        result = game.stalemate?(game.send(:black_player))
        expect(result).to be(false)
      end
    end
  end

  describe "#king_taken?" do
    context "with the last taken_piece element being of type King" do
      it "returns true" do
        game.taken_pieces << [King.new(:black, 0,0), '1000']
        result = game.king_taken?
        expect(result).to be(true)
      end
    end
    
    context "with taken_piece empty" do
      it "returns false" do
        game.taken_pieces
        result = game.king_taken?
        expect(result).to be(false)
      end
    end
  end
end