require_relative '../lib/game'

describe Game do
  let(:game) {Game.new}
  before do
    allow($stdin).to receive(:gets).and_return("John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep)
  end
  
  it 'received sleep' do
    expect(game).to have_received(:sleep).exactly(302).times
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
    it 'should not save move if formatted incorrectly' do
    end
    
    it 'should not save move if not a genuine move' do
    end
  end
end