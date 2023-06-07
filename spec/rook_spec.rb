require_relative '../lib/pieces/rook'

describe Rook do
  describe "a Rook's instantiation" do
    it 'sets and makes readable colour, x, y and first_movevariables' do
      white_rook = Rook.new(:white, 0,0)
      rooks_colour = white_rook.colour
      rooks_x_coor = white_rook.x
      rooks_y_coor = white_rook.y
      rooks_first_move = white_rook.first_move?
      expect(rooks_colour).to equal(:white)
      expect(rooks_x_coor).to equal(0)
      expect(rooks_y_coor).to equal(0)
      expect(rooks_first_move).to be(true)
    end
  end

  describe '#first_move_made' do
    it "sets rook's @first move to false" do
      white_rook = Rook.new(:white, 0,0)
      expect(white_rook.first_move?).to be(true)
      white_rook.first_move_made
      expect(white_rook.first_move?).to be(false)
    end
  end
end