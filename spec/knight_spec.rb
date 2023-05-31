require_relative '../lib/pieces/knight'
# require_relative 'knight'

describe Knight do
  let(:white_knight) { Knight.new(:white, 3,3) }
  describe "a knight object's colour, x and y variables" do
    it 'are given to it on instantiaton and are readable' do
      knights_colour = white_knight.colour
      knights_x_coor = white_knight.x
      knights_y_coor = white_knight.y
      expect(knights_colour).to equal(:white)
      expect(knights_x_coor).to equal(3)
      expect(knights_y_coor).to equal(3)
    end
  end

  describe "#all_knights_moves" do
    context 'with a knight in coords 3,3' do
      it 'has 8 L shaped move possibilities' do
        result = white_knight.all_knights_moves
        moves_array = [[5, 4],[5, 2],[1, 4],[1, 2],[4, 5],[2, 5],[4, 1],[2, 1]]
        expect(result).to eq(moves_array)
      end
    end
  end
end