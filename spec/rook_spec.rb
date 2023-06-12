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

  describe '#first_move_taken' do
    it "sets rook's @first move to false" do
      white_rook = Rook.new(:white, 0,0)
      expect(white_rook.first_move?).to be(true)
      white_rook.first_move_taken
      expect(white_rook.first_move?).to be(false)
    end
  end

  describe '#valid_rook_moves' do
    context 'with a rook in position 0,0' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 0,0)
        result = white_rook.valid_rook_moves
        expect(result).to eq([[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
          [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]])
      end
    end

    context 'with a rook in position 0,7' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 0,7)
        result = white_rook.valid_rook_moves
        expect(result).to eq([[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6],
          [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]])
      end
    end
    
    context 'with a rook in position 7,0' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 7,0)
        result = white_rook.valid_rook_moves
        expect(result).to eq([[7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7],
          [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]])
      end
    end
    
    context 'with a rook in position 7,7' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 7,7)
        result = white_rook.valid_rook_moves
        expect(result).to eq([[7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6],
          [0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7]])
      end
    end
    
    context 'with a rook in position 3,3' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 3,3)
        result = white_rook.valid_rook_moves
        expect(result).to eq([[3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7], 
          [0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3]])
      end
    end
  end
end