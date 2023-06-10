require_relative '../lib/pieces/bishop'

describe Bishop do
  describe "a bishop's instantiation" do
    it 'sets and makes readable colour, x, y and first_move variables' do
      white_bishop = Bishop.new(:white, 0,2)
      bishops_colour = white_bishop.colour
      bishops_x_coor = white_bishop.x
      bishops_y_coor = white_bishop.y
      bishops_first_move = white_bishop.first_move?
      expect(bishops_colour).to equal(:white)
      expect(bishops_x_coor).to equal(0)
      expect(bishops_y_coor).to equal(2)
      expect(bishops_first_move).to be(true)
    end
  end

  describe '#first_move_taken' do
    it "sets bishop's @first move from true to false" do
      white_bishop = Bishop.new(:white, 0,2)
      expect(white_bishop.first_move?).to be(true)
      white_bishop.first_move_taken
      expect(white_bishop.first_move?).to be(false)
    end
  end
end