require_relative '../lib/pieces/queen'

describe Queen do
  describe "a queen's instantiation" do
    it 'sets and makes readable colour, x, y and first_movevariables' do
      white_queen = Queen.new(:white, 0, 3)
      queens_colour = white_queen.colour
      queens_x_coor = white_queen.x
      queens_y_coor = white_queen.y
      queens_first_move = white_queen.first_move?
      expect(queens_colour).to equal(:white)
      expect(queens_x_coor).to equal(0)
      expect(queens_y_coor).to equal(3)
      expect(queens_first_move).to be(true)
    end
  end

  describe '#first_move_made' do
    it "sets queen's @first move to false" do
      white_queen = Queen.new(:white, 0, 3)
      expect(white_queen.first_move?).to be(true)
      white_queen.first_move_made
      expect(white_queen.first_move?).to be(false)
    end
  end
end
