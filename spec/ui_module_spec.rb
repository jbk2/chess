require_relative '../lib/ui_module'
require_relative '../lib/game'

describe UiModule do
  let(:game) { Game.new }

  before do
    allow($stdin).to receive(:gets).and_return("John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep) # stubs any #sleep's for test running speed
  end

  
  describe "#chess_format(index_move)" do
  it 'takes indexed move and returns it in chess move format' do
    result = game.chess_format('1011')
    expect(result).to eq('2a,2b')
  end
end

  describe "#chess_notation?(move)" do
    it 'returns true if formatted in chess notation correctly' do
      result = game.chess_notation?('a1,a2')
      expect(result).to be(true)
    end
    it 'returns false if formatted in chess notation correctly' do
      result = game.chess_notation?('1a,2a')
      expect(result).to be(false)
    end
  end

  describe "#index_format(chess_move)" do
    it 'takes chess move format and returns it in indexed format' do
      result = game.index_format('1a,1b')
      expect(result).to eq('0001')
    end
  end
  
  describe "#chess_notation_to_index_format(chess_move)" do
    it "correctly converts chess notation 'a8,a7' to 4 digit index format" do
      result = game.chess_notation_to_index_format('a8,a7')
      expect(result).to eq('0010')
    end
    
    it "correctly converts chess notation 'g1,h2' to 4 digit index format" do
      result = game.chess_notation_to_index_format('g1,h2')
      expect(result).to eq('7667')
    end
    
    it "correctly converts chess notation 'c3,g7' to 4 digit index format" do
      result = game.chess_notation_to_index_format('c3,g7')
      expect(result).to eq('5216')
    end
  end
end