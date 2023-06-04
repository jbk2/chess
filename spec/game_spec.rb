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
    it 'should have a board' do
      expect(game.board).to be_instance_of(Board)
    end

    it 'should have a player1' do
      expect(game.player1).to be_instance_of(Player)
    end
    
    it 'should have a player2' do
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
        expect(active_player).to receive(:add_move).with('a1,a2').once
        game.send(:get_move)
      end
    end
  end

end