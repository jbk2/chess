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

  describe "#add_move(move)" do
    context 'with a valid format' do
      it "returns the given valid move" do
        expect(player1.add_move('0001')).to eq(['0001'])
        expect(player1.moves).to eq(['0001'])
      end

      it "stores the move to the player's readable @moves" do
        player1.add_move('0001')
        expect(player1.moves).to eq(['0001'])
      end
    end
    
    context 'with validly formatted, but without a real one square to another real piece movement' do
      it "doesn't add move to player's @moves" do
        expect {
          player1.add_move('0000')
          player1.add_move('0000')
        }.to raise_error(InvalidInputError)
        expect(player1.moves).to eq([])
      end
    end

    context 'with an invalid input format' do
      it "doesn't add move to player's @moves" do
        expect { player1.add_move('a1,a23') }.to raise_error(InvalidInputError)
      end
    end
  end
end