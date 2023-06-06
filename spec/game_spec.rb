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

  context 'it is constructed with' do
    it 'a board' do
      expect(game.board).to be_instance_of(Board)
    end

    it 'a player1' do
      expect(game.player1).to be_instance_of(Player)
    end
    
    it 'a player2' do
      expect(game.player2).to be_instance_of(Player)
    end
  end

  describe "#assign_colour" do
    it "should assign a colour to each player" do
      expect([:white, :black]).to include(game.player1.colour)
      expect([:white, :black]).to include(game.player2.colour)
      # expect(game.player2.colour).to eq(:white).or(be == :black) #alternatively
    end
  end
  
  describe "active_player logic" do
    it 'starts a game with the active_player always the white player' do
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

  describe '#get_move' do
    let(:active_player) { double(Player) }
    
    context 'when move is valid' do
      before do
        allow(game).to receive(:get_input).and_return('b1,c1') # Pawn
        allow(game).to receive(:move_valid_format?).and_return(true)
        allow(game).to receive(:true_move?).and_return(true)
        allow(active_player).to receive(:moves).and_return([])
        allow(game).to receive(:pawn_or_knight_move?).and_return(true)
        allow(game).to receive(:active_player).and_return(active_player)
      end
      
      it "saves the move on the active_player's @moves variable" do
        expect(active_player).to receive(:add_move).with('1020').once #Rook
        game.send(:get_move)
      end
    end

    context 'when the move is invalid' do
      before do
        allow(game).to receive(:active_player).and_return(active_player)
      end

      it "will not save move when formatted incorrectly" do
        allow(game).to receive(:get_input).and_return('aaa1,asdff2', 'a1,a2')
        allow(game).to receive(:move_valid_format?).and_return(false, true)
        allow(game).to receive(:true_move?).and_return(true)
        allow(game).to receive(:pawn_or_knight_move?).and_return(false, true)
        allow(active_player).to receive(:moves).and_return([])

        expect(active_player).not_to receive(:add_move).with('0001111001001')
        game.send(:get_move)
      end
      
      it "will not save move when it's not a genuine move from one square to another" do
        allow(game).to receive(:get_input).and_return('a1,a1', 'a1,a2')
        allow(game).to receive(:move_valid_format?).and_return(true, true)
        allow(game).to receive(:true_move?).and_return(false, true)
        allow(game).to receive(:pawn_or_knight_move?).and_return(false, true)
        allow(active_player).to receive(:moves).and_return([])

        expect(active_player).not_to receive(:add_move).with('0000')
        game.send(:get_move)
      end
    end

    context "On player's first move" do
      context "it won't save" do
        before do
          allow(game).to receive(:active_player).and_return(active_player)
          allow(game).to receive(:move_valid_format?).and_return(true, true) #
          allow(game).to receive(:true_move?).and_return(true, true) #
          allow(active_player).to receive(:moves).and_return([])
          allow(game).to receive(:pawn_or_knight_move?).and_return(false, true) #
        end

        it "a Rook move" do
          allow(game).to receive(:get_input).and_return('a1,c1', 'a2,c3') #Rook & Knight 
          expect(active_player).not_to receive(:add_move).with('0020') 
          expect(active_player).to receive(:add_move).with('0122')
          game.send(:get_move)
        end
        it "a Bishop move" do
          allow(game).to receive(:get_input).and_return('a3,c5', 'a2,c3') #Bishop & Knight 
          expect(active_player).not_to receive(:add_move).with('0224') 
          expect(active_player).to receive(:add_move).with('0122')
          game.send(:get_move)
        end
        it "a Queen move" do
          allow(game).to receive(:get_input).and_return('a4,c6', 'b1,c1') #Queen & Pawn 
          expect(active_player).not_to receive(:add_move).with('0325') 
          expect(active_player).to receive(:add_move).with('1020')
          game.send(:get_move)
        end
        it "a King move" do
          allow(game).to receive(:get_input).and_return('a5,b5', 'b2,c2') #King & Pawn 
          expect(active_player).not_to receive(:add_move).with('0414') 
          expect(active_player).to receive(:add_move).with('1121')
          game.send(:get_move)
        end
      end
      
      context "it will save" do
        before do
          allow(game).to receive(:active_player).and_return(active_player)
          allow(game).to receive(:move_valid_format?).and_return(true)
          allow(game).to receive(:true_move?).and_return(true)
          allow(active_player).to receive(:moves).and_return([])
          allow(game).to receive(:pawn_or_knight_move?).and_return(true)
        end

        it "will save a Pawn move" do
          allow(game).to receive(:get_input).and_return('b2,c2') #Pawn  
          expect(active_player).to receive(:add_move).with('1121')
          game.send(:get_move)
        end
        it "will save a Knight move" do
          allow(game).to receive(:get_input).and_return('a2,c3') #Knight 
          expect(active_player).to receive(:add_move).with('0122')
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
        expect(result).to be(false)
      end
      it 'with a Knight' do
        result = game.send(:pawn_or_knight_move?, '0122')
        expect(result).to be(false)
      end
    end
  end
  
  describe 'first move allows only Pawn or Knight moves, implemented by Game#get_move' do
    let(:active_player) { double(Player) }
  end

  describe "#format_to_index" do
    it 'takes chess input format and outputs in array index format' do
      result = Game.send(:format_to_index, 'a1,a2')
      expect(result).to eq('0001')
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
    
    context 'with a valid Pawn move' do
      it "calls the Pawn's #piece_valid_move?" do
        moves = ['1020']
        allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
        allow(active_player).to receive(:moves).and_return(moves)
        allow(board).to receive(:grid).and_return(@grid)
        expect(pawn_move_piece).to receive(:piece_valid_move?).with('1020')
        game.make_move
      end
    end

    context 'with a valid Rook move' do
      it "calls Rooks#piece_valid_move?" do
        moves = ['0001']
        allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
        allow(active_player).to receive(:moves).and_return(moves)
        allow(board).to receive(:grid).and_return(@grid)
        expect(rook_move_piece).to receive(:piece_valid_move?).with('0001')
        game.make_move
      end
    end

    context 'with a valid Knight move' do
      it "calls Knight#piece_valid_move?" do
        moves = ['0123']
        allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
        allow(active_player).to receive(:moves).and_return(moves)
        # allow(knight_move_piece).to receive(:x).and_return(0)
        allow(board).to receive(:grid).and_return(@grid)
        expect(knight_move_piece).to receive(:piece_valid_move?).with('0123')
        # expect(knight_move_piece).to receive(:x).and_return('0')
        game.make_move
      end
    end

    context 'with a valid Bishop move' do
      it "calls Bishop#piece_valid_move?" do
        moves = ['0213']
        allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
        allow(active_player).to receive(:moves).and_return(moves)
        allow(board).to receive(:grid).and_return(@grid)
        expect(bishop_move_piece).to receive(:piece_valid_move?).with('0213')
        game.make_move
      end
    end

    context 'with a valid Queen move' do
      it "calls Queen#piece_valid_move?" do
        moves = ['7351']
        allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
        allow(active_player).to receive(:moves).and_return(moves)
        allow(board).to receive(:grid).and_return(@grid)
        expect(queen_move_piece).to receive(:piece_valid_move?).with('7351')
        game.make_move
      end
    end

    context 'with a valid King move' do
      it "calls King#piece_valid_move?" do
        moves = ['7463']
        allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
        allow(active_player).to receive(:moves).and_return(moves)
        allow(board).to receive(:grid).and_return(@grid)
        expect(king_move_piece).to receive(:piece_valid_move?).with('7463')
        game.make_move
      end
    end

      # it "changes the piece's position" do
      # end
    
    context 'with an invalid move' do
      # it "does not change the piece's position" do
      # end
    end
  end

  describe 'only the active player can make a move' do
  end
end