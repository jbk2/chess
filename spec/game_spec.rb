require_relative '../lib/game'

describe Game do
  let(:game) {Game.new}
  before do
    allow($stdin).to receive(:gets).and_return("John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep)
  end
  
  it 'received sleep' do
    expect(game).to have_received(:sleep).at_least(:once)
  end

  context 'should be constructed with' do
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
    it "it should be as assigned" do
      expect([:white, :black]).to include(game.player1.colour)
      expect([:white, :black]).to include(game.player2.colour)
      # expect(game.player2.colour).to eq(:white).or(be == :black) #alternatively
    end
  end
  
  describe "active_player logic" do
    it 'commencing game active player should be white player' do
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
    context 'when the move is invalid' do
      before do
        allow(game).to receive(:active_player).and_return(active_player)
      end

      it "should not save move if it's not formatted correctly" do
        allow(game).to receive(:get_input).and_return('aaa1,asdff2', 'a1,a2')
        allow(game).to receive(:move_valid_format?).and_return(false, true)
        allow(game).to receive(:true_move?).and_return(true)

        expect(active_player).not_to receive(:add_move).with('aaa1,asdff2')
        game.send(:get_move)
      end
      
      it "should not save move if it's not a genuine move" do
        allow(game).to receive(:get_input).and_return('a1,a1', 'a1,a2')
        allow(game).to receive(:move_valid_format?).and_return(true)
        allow(game).to receive(:true_move?).and_return(false, true)

        expect(active_player).not_to receive(:add_move).with('a1,a1')
        game.send(:get_move)
      end
    end
    
    context 'when move is valid' do
      before do
        allow(game).to receive(:get_input).and_return('a1,a2')
        allow(game).to receive(:move_valid_format?).and_return(true)
        allow(game).to receive(:true_move?).and_return(true)
        allow(game).to receive(:active_player).and_return(active_player)
      end
      
      it 'saves the move on the active_player' do
        expect(active_player).to receive(:add_move).with('0001').once
        game.send(:get_move)
      end
    end
  end
  
  describe "#format_to_index" do
    it 'takes chess input and outputs array index values' do
      result = Game.send(:format_to_index, 'a1,a2')
      expect(result).to eq('0001')
    end
  end

  describe '#has_piece?(square)' do
    context 'when there is a piece in the given square' do
      it 'returns true' do
        expect(game.send(:has_piece?, 0, 0)).to be(true)
      end
    end  
    
    context 'when there is no piece in the given square' do
      it 'returns false' do
        expect(game.send(:has_piece?, 2, 0)).to be(false)
      end
    end 
  end

  describe '#make_move' do
    context 'with a valid move' do
      let(:active_player) { instance_double(Player) }
      let(:move_piece) { instance_double(Rook)}
      let(:board) { double('Board') }
      it "calls the piece's #valid_move method" do
        moves = ['0001']
        allow(active_player).to receive(:instance_variable_get).with(:@moves).and_return(moves)
        allow(active_player).to receive(:moves).and_return(moves)
        allow(game).to receive(:active_player).and_return(active_player)
        allow(game).to receive(:board).and_return(board) 
        grid = [[move_piece, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil]]

        allow(board).to receive(:grid).and_return(grid)

        expect(move_piece).to receive(:piece_valid_move?).with('0001')#.and_return(true)
        game.make_move
      end

      # it "changes the piece's position" do
      # end
    end
    
    context 'with an invalid move' do
      # it "does not change the piece's position" do
      # end
    end
  end

  describe 'only the active player can make a move' do
  end
end