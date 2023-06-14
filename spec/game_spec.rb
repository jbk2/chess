require_relative '../lib/game'

describe Game do
  let(:game) {Game.new}
  before do
    allow($stdin).to receive(:gets).and_return("John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep) # stubs any #sleep's for test running speed
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
      # expect(game.player2.colour).to eq(:white).or(be == :black) #alternatively
    end
  end
  
  describe "active_player" do
    it 'is also the white player' do
      orig_active_player = game.active_player
      expect(game.active_player).to eq(game.send(:white_player))
    end

    describe "#change_turn" do
      it "should change the game.active_player" do
        orig_active_player = game.active_player
        expect(game.active_player).to eq(orig_active_player)
        game.send(:toggle_turn)
        expect(game.active_player).not_to eq(orig_active_player)
      end
    end
  end

  describe '#add_move(move)' do
    context 'with correct index format' do 
      it 'pushes a the move string onto the @moves array' do
        game.add_move('1011')
        expect(game.moves).to eq(['1011'])
      end
    end
    
    context 'with incorrect index format' do
        it 'raises and InputError' do
          expect { game.add_move('1b,1c') }.to raise_error(InputError, "Indexed_move; 1b,1c should be formatted like 'iiii'")
          expect(game.moves).to eq([])
        end
      end
  end

  describe '#get_move' do
    let(:active_player) { double(Player) }
    
    context 'when move is valid' do
      before do
        allow(game).to receive(:get_input).and_return('2a,3a') # Pawn
      end
      
      it "saves the move in the Game @moves array" do
        allow(game).to receive(:moves).and_return(['1020'])
        expect(game).to receive(:add_move).with('1020').once #Pawn
        expect(game.moves.last).to eq('1020')
        game.send(:get_move)
      end
    end

    context 'when the move is invalid' do
      it "will not save move when formatted incorrectly" do
        allow(game).to receive(:get_input).and_return('aaa1,asdff2', '2a,3a') # Nil, Rook
        allow(game).to receive(:pawn_or_knight_move?).and_return(false, true)

        expect(game).not_to receive(:add_move).with('0001111001001')
        game.send(:get_move)
      end
      
      it "will not save move when it's not a genuine move from one square to another" do
        allow(game).to receive(:get_input).and_return('2a,2a', '2a,3a') # Pawn & Pawn
        allow(game).to receive(:true_move?).and_return(false, true)

        expect(game).not_to receive(:add_move).with('1010')
        expect(game).to receive(:add_move).with('1020')
        game.send(:get_move)
      end
    end

    context "On player's first move" do
      context "it won't save" do
        it "a Rook move" do
          allow(game).to receive(:get_input).and_return('1a,3a', '1b,3c') #Rook & Knight 
          expect(game).not_to receive(:add_move).with('0020')
          expect(game).to receive(:add_move).with('0122')
          game.send(:get_move)
        end

        it "a Bishop move" do
          allow(game).to receive(:get_input).and_return('1c,3e', '1b,3c') #Bishop & Knight
          expect(game).not_to receive(:add_move).with('0224') 
          expect(game).to receive(:add_move).with('0122')
          game.send(:get_move)
        end
        it "a Queen move" do
          allow(game).to receive(:get_input).and_return('1d,3f', '2a,3a') #Queen & Pawn 
          expect(game).not_to receive(:add_move).with('0325') 
          expect(game).to receive(:add_move).with('1020')
          game.send(:get_move)
        end
        it "a King move" do
          allow(game).to receive(:get_input).and_return('1e,2e', '2b,3b') #King & Pawn 
          expect(game).not_to receive(:add_move).with('0414') 
          expect(game).to receive(:add_move).with('1121')
          game.send(:get_move)
        end
      end
      
      context "it will save" do
        it "will save a Pawn move" do
          allow(game).to receive(:get_input).and_return('2b,3b') #Pawn  
          expect(game).to receive(:add_move).with('1121')
          game.send(:get_move)
        end
        it "will save a Knight move" do
          allow(game).to receive(:get_input).and_return('1b,3c') #Knight 
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
  
  describe 'first move allows only Pawn or Knight moves, implemented by Game#get_move' do
    let(:active_player) { double(Player) }
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

  describe '#make_move' do
    let(:active_player) { instance_double(Player) }
    let(:board) { double('Board') }
    let(:pawn_move_piece) { instance_double(Pawn)}
    let(:rook_move_piece) { instance_double(Rook)}
    let(:knight_move_piece) { instance_double(Knight)}
    let(:bishop_move_piece) { instance_double(Bishop)}
    let(:queen_move_piece) { instance_double(Queen)}
    let(:king_move_piece) { instance_double(King)}
    
    before do
      allow_any_instance_of(Game).to receive(:sleep).at_least(:once)
      allow(game).to receive(:active_player).and_return(active_player)
      allow(game).to receive(:board).and_return(board) 
      @grid = [[rook_move_piece, knight_move_piece, bishop_move_piece, queen_move_piece, king_move_piece, bishop_move_piece, knight_move_piece, rook_move_piece],
      [pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece, pawn_move_piece],
      [rook_move_piece, knight_move_piece, bishop_move_piece, queen_move_piece, king_move_piece, bishop_move_piece, knight_move_piece, rook_move_piece]
      ]
    end
    
    # context 'with a valid Pawn move' do
    #   it "calls the Pawn's #piece_valid_move?" do
    #     moves = ['1020']
    #     allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
    #     allow(active_player).to receive(:moves).and_return(moves)
    #     allow(board).to receive(:grid).and_return(@grid)
    #     expect(pawn_move_piece).to receive(:piece_valid_move?).with('1020')
    #     game.make_move
    #   end
    # end

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
    
    context 'with an invalid move' do
      # it "does not change the piece's position" do
      # end
    end
  end

  describe '#game_valid_move?' do
    
  end

  # describe 'only the active player can make a move' do
  # end
  # describe 'is in check?' do
  # end

  describe '#move_path_clear(move)' do
    context 'when move path is clear' do
      context 'with a neigbouring square move' do
        it "returns true because move is a neighbouring square" do
          result = game.send(:move_path_clear?, '2030')
          expect(result).to be(true)
        end
      end
      
      context 'with a straight down move of 2 squares' do
        it "returns true because there are no pieces inbetween" do
          result = game.send(:move_path_clear?, '2040')
          expect(result).to be(true)
        end
      end
      
      context 'with a straight up move of 3 squares' do
        it "returns true because there's no pieces inbetween" do
          result = game.send(:move_path_clear?, '6030')
          expect(result).to be(true)
        end
      end
      
      context 'with a left move of 3 squares' do
        it "returns true because there's no pieces inbetween" do
          result = game.send(:move_path_clear?, '5350')
          expect(result).to be(true)
        end
      end
      
      context 'with a right move of 4 squares' do
        it "returns true because there's no pieces inbetween" do
          result = game.send(:move_path_clear?, '5054')
          expect(result).to be(true)
        end
      end
      
      context 'with a down right move of 3 squares' do
        it "returns true because there's no pieces inbetween" do
          result = game.send(:move_path_clear?, '2053')
          expect(result).to be(true)
        end
      end
      
      context 'with a down left move of 4 squares' do
        it "returns true because there's no pieces inbetween" do
          result = game.send(:move_path_clear?, '1753')
          expect(result).to be(true)
        end
      end
      
      context 'with up right move of 4 squares' do
        it "returns true because there's no pieces inbetween" do
          result = game.send(:move_path_clear?, '6226')
          expect(result).to be(true)
        end
      end
      
      context 'with up left move of 4 squares' do
        it "returns true because there's no pieces inbetween" do
          result = game.send(:move_path_clear?, '6723')
          expect(result).to be(true)
        end
      end
    end
    
    context 'when move path is not clear' do
      context 'with a straight down move of 2 squares' do
        it "returns false because there's a piece inbetween" do
          result = game.send(:move_path_clear?, '0020')
          expect(result).to be(false)
        end
      end
     
      context 'with a straight up move of 3 squares' do
        it "returns false because there's a piece inbetween" do
          game.board.grid[5][0] = Pawn.new(:white, 5, 0)
          result = game.send(:move_path_clear?, '7040')
          expect(result).to be(false)
        end
      end
      
      context 'with a left move of 3 squares' do
        it "returns false because there's a piece inbetween" do
          result = game.send(:move_path_clear?, '6360')
          expect(result).to be(false)
        end
      end
      
      context 'with a right move of 4 squares' do
        it "returns false because there's a piece inbetween" do
          result = game.send(:move_path_clear?, '7074')
          expect(result).to be(false)
        end
      end

      context 'with a down right move of 3 squares' do
        it "returns false because there's pieces inbetween" do
          game.board.grid[3][1] = Pawn.new(:white, 3, 1)
          game.board.grid[4][2] = Pawn.new(:white, 4, 2)
          result = game.send(:move_path_clear?, '2053')
          expect(result).to be(false)
        end
      end

      context 'with a down left move of 4 squares' do
        it "returns false because there's pieces inbetween" do
          game.board.grid[2][6] = Pawn.new(:white, 2, 6)
          game.board.grid[4][4] = Pawn.new(:white, 4, 4)
          result = game.send(:move_path_clear?, '1753')
          expect(result).to be(false)
        end
      end

      context 'with up right move of 4 squares' do
        it "returns false because there's pieces inbetween" do
          game.board.grid[4][4] = Pawn.new(:white, 4, 4)
          game.board.grid[3][5] = Pawn.new(:white, 3, 5)
          result = game.send(:move_path_clear?, '6226')
          expect(result).to be(false)
        end
      end

      context 'with up left move of 4 squares' do
        it "returns false because there's pieces inbetween" do
          game.board.grid[5][6] = Pawn.new(:white, 5, 6)
          game.board.grid[4][5] = Pawn.new(:white, 4, 5)
          game.board.grid[2][3] = Pawn.new(:white, 2, 3)
          result = game.send(:move_path_clear?, '6723')
          expect(result).to be(false)
        end
      end
    end
  end

  describe '#in_check?(player)' do
    context 'when given player is not in check' do
      it 'returns false' do
        result = game.in_check?(game.active_player)
        expect(result).to be(false)
      end
      
      it 'returns false' do
        game.board.grid[6][4] = nil
        game.board.grid[5][4] = Rook.new(:white, 5, 4)
        result = game.in_check?(game.active_player)
        expect(result).to be(false)
      end
      
      it 'returns false' do
        game.send(:toggle_turn)
        game.board.grid[1][4] = Pawn.new(:white, 1, 4)
        result = game.in_check?(game.active_player)
        expect(result).to be(false)
      end
    end
    
    context 'when given player is in check' do
      it 'returns true' do
        game.board.grid[6][4] = nil
        game.board.grid[5][4] = Rook.new(:black, 5, 4)
        result = game.in_check?(game.active_player)
        expect(result).to be(true)
      end
      
      it 'returns true' do
        game.board.grid[6][4] = nil
        game.board.grid[6][5] = nil
        game.board.grid[4][7] = Bishop.new(:black, 4, 7)
        result = game.in_check?(game.active_player)
        expect(result).to be(true)
      end
      
      it 'returns true' do
        game.board.grid[7][4] = nil
        game.board.grid[5][4] = King.new(:white, 5, 4)
        game.board.grid[1][0] = Bishop.new(:black, 1, 0)
        result = game.in_check?(game.active_player)
        expect(result).to be(true)
      end
      
      it 'returns true' do
        game.board.grid[7][4] = nil
        game.board.grid[5][4] = King.new(:white, 5, 4)
        game.board.grid[4][3] = Pawn.new(:black, 4, 3)
        result = game.in_check?(game.active_player)
        expect(result).to be(true)
      end
      
      it 'returns true' do
        game.board.grid[1][3] = Pawn.new(:white, 1, 3)
        game.send(:toggle_turn)
        result = game.in_check?(game.active_player)
        expect(result).to be(true)
      end
    end
  end

  describe '#place_move(move)' do
    context 'with no piece taking' do
      it 'moves piece from src to dst square' do
        expect(game.board.grid[2][0]).to be_nil
        game.place_move('1020')
        expect(game.board.grid[2][0]).to be_a(Pawn)
        expect(game.board.grid[1][0]).to be_nil
      end
    end
    
    context 'with piece taking' do
      it 'moves piece from src to dst & taken piece into @taken_pieces with move record' do
        move = '1020'
        game.board.grid[2][0] = Rook.new(:white, 2, 0)
        expect(game.board.grid[2][0]).to be_a(Rook)
        expect(game.board.grid[1][0]).to be_a(Pawn)
        game.place_move(move)
        expect(game.board.grid[2][0]).to be_a(Pawn)
        expect(game.board.grid[1][0]).to be_nil
        expect(game.taken_pieces.last[0]).to be_a(Rook)
        expect(game.taken_pieces.last[1]).to eq(move)
      end
    end
  end

  describe '#rollback_move(move)' do
    context 'without a taken piece on last move' do
      it 'reverses back the last move' do
        move = '1020'
        game.board.grid[2][0] = Rook.new(:white, 2, 0)
        game.place_move(move)
        expect(game.board.grid[2][0]).to be_a(Pawn)
        expect(game.board.grid[1][0]).to be_nil
        expect(game.taken_pieces.last[0]).to be_a(Rook)
        expect(game.taken_pieces.last[1]).to eq(move)
        game.rollback_move(move)
        expect(game.board.grid[1][0]).to be_a(Pawn)
        expect(game.board.grid[2][0]).to be_a(Rook)
        expect(game.taken_pieces.last).to satisfy { |piece| piece.nil? || !piece.is_a?(Rook) }
        expect(game.taken_pieces.last).to satisfy { |piece| piece.nil? || !piece.eq(move) }
      end
    end
  end

end