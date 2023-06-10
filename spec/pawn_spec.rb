require_relative '../lib/pieces/pawn'

describe Pawn do
  describe "a pawn's instantiation" do
    it 'sets and makes readable colour, x, y and first_movevariables' do
      white_pawn = Pawn.new(:white, 1,0)
      pawns_colour = white_pawn.colour
      pawns_x_coor = white_pawn.x
      pawns_y_coor = white_pawn.y
      pawns_first_move = white_pawn.first_move?
      expect(pawns_colour).to equal(:white)
      expect(pawns_x_coor).to equal(1)
      expect(pawns_y_coor).to equal(0)
      expect(pawns_first_move).to be(true)
    end
  end

  describe '#first_move_taken' do
    it "sets pawn's @first move to false" do
      white_pawn = Pawn.new(:white, 1,0)
      expect(white_pawn.first_move?).to be(true)
      white_pawn.first_move_taken
      expect(white_pawn.first_move?).to be(false)
    end
  end
end