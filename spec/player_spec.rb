require_relative '../lib/player'

describe Player do
  let(:player1) { Player.new('James') }
  describe "a player's name" do
    it 'is readable' do
      expect(player1.name).to eq("James")
    end
  end
  
  describe "a player's colour" do
    it 'is readable' do
      player1.colour = :white
      expect(player1.colour).to equal(:white)
    end
  end
  
  describe '#first_move_made' do
    it "sets player's @first move to false" do
      expect(player1.first_move?).to be(true)
      player1.first_move_made
      expect(player1.first_move?).to be(false)
    end
  end
  
end