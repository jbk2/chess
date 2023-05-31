require_relative '../lib/player'

describe Player do
  let(:player_1) { Player.new('James') }
  describe "a player's name" do
    it 'is readable' do
      expect(player_1.name).to eq("James")
    end
  end
  
  describe "a player's colour" do
    it 'is readable' do
      player_1.colour = :white
      expect(player_1.colour).to equal(:white)
    end
  end
end