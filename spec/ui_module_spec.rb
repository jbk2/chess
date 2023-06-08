require_relative '../lib/ui_module'
require_relative '../lib/game'

describe UiModule do
  let(:game) { Game.new }

  before do
    allow($stdin).to receive(:gets).and_return("John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep) # stubs any #sleep's for test running speed
  end

  describe "#index_format(chess_move)" do
    it 'takes chess move format and returns it in indexed format' do
      result = game.index_format('1a,1b')
      expect(result).to eq('0001')
    end
  end
  
  describe "#chess_format(index_move)" do
    it 'takes indexed move and returns it in chess move format' do
      result = game.chess_format('1011')
      expect(result).to eq('2a,2b')
    end
  end

end