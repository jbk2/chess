require_relative '../lib/pieces/king'

describe King do
  describe "a king's instantiation" do
    it 'sets and makes readable colour, x, y and first_movevariables' do
      white_king = King.new(:white, 0,4)
      kings_colour = white_king.colour
      kings_x_coor = white_king.x
      kings_y_coor = white_king.y
      kings_first_move = white_king.first_move?
      expect(kings_colour).to equal(:white)
      expect(kings_x_coor).to equal(0)
      expect(kings_y_coor).to equal(4)
      expect(kings_first_move).to be(true)
    end
  end

  describe '#first_move_made' do
    it "sets king's @first move to false" do
      white_king = King.new(:white, 0,4)
      expect(white_king.first_move?).to be(true)
      white_king.first_move_made
      expect(white_king.first_move?).to be(false)
    end
  end
end