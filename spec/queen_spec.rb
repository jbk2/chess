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

  describe '#first_move_taken' do
    it "sets queen's @first move to false" do
      white_queen = Queen.new(:white, 0, 3)
      expect(white_queen.first_move?).to be(true)
      white_queen.first_move_taken
      expect(white_queen.first_move?).to be(false)
    end
  end

  describe '#all_queen_move' do
    context 'with a queen in square 0,3' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_queen = Queen.new(:white, 0,3)
        result = white_queen.all_queen_moves
        expect(result).to include([1, 4], [2, 5], [3, 6], [4, 7], [1, 2],
          [2, 1], [3, 0], [0, 4], [0, 5], [0, 6], [0, 7], [0, 2], [0, 1], [0, 0],
          [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3])
      end
    end
    
    context 'with a queen in square 4,3' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_queen = Queen.new(:white, 4,3)
        result = white_queen.all_queen_moves
        expect(result).to eq([[5, 4], [6, 5], [7, 6], [5, 2], [6, 1], [7, 0],
        [3, 4], [2, 5], [1, 6], [0, 7], [3, 2], [2, 1], [1, 0], [0, 3], [1, 3],
        [2, 3], [3, 3], [5, 3], [6, 3], [7, 3], [4, 0], [4, 1], [4, 2], [4, 4],
        [4, 5], [4, 6], [4, 7]])
      end
    end
    
    context 'with a queen in square 3,3' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_queen = Queen.new(:white, 3,3)
        result = white_queen.all_queen_moves
        expect(result).to include([4, 4], [5, 5], [6, 6], [7, 7], [4, 2], [5, 1], [6, 0],
          [2, 4], [1, 5], [0, 6], [2, 2], [1, 1], [0, 0], [2, 3], [1, 3], [0, 3], [4, 3],
          [5, 3], [6, 3], [7, 3], [3, 2], [3, 1], [3, 0], [3, 4], [3, 5], [3, 6], [3, 7])
        expect(result.length).to be(27)
      end
    end
   
    context 'with a queen in square 2,5' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_queen = Queen.new(:white, 2,5)
        result = white_queen.all_queen_moves
        expect(result).to include([3,6], [4,7], [3,4], [4,3], [5, 2], [6, 1],
        [7, 0], [1, 6], [0, 7], [1, 4], [0, 3], [1, 5], [0, 5], [3, 5], [4, 5], [5, 5],
        [6, 5], [7, 5], [2, 4], [2, 3], [2, 2], [2, 1], [2, 0], [2, 6], [2, 7])
        expect(result.length).to be(25)
      end
    end
    
    context 'with a queen in square 5,3' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_queen = Queen.new(:white, 5,3)
        result = white_queen.all_queen_moves
        expect(result).to include([6, 4], [7, 5], [6, 2], [7, 1], [4, 4], [3, 5],
        [2, 6], [1, 7], [4, 2], [3, 1], [2, 0], [4, 3], [3, 3], [2, 3], [1, 3], [0, 3],
        [6, 3], [7, 3], [5, 2], [5, 1], [5, 0], [5, 4], [5, 5], [5, 6], [5, 7])
        expect(result.length).to be(25)
      end
    end
    
    context 'with a queen in square 7,7' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_queen = Queen.new(:white, 7,7)
        result = white_queen.all_queen_moves
        expect(result).to include([6, 6], [5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0, 0],
        [6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7], [0, 7], [7, 6], [7, 5], [7, 4],
        [7, 3], [7, 2],  [7, 1], [7, 0])
        expect(result.length).to be(21)
      end
    end

  end
end
