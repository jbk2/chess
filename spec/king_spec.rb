require_relative '../lib/pieces/king'
require_relative '../lib/board'

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

  describe '#first_move_taken' do
    it "sets king's @first move to false" do
      white_king = King.new(:white, 0,4)
      expect(white_king.first_move?).to be(true)
      white_king.first_move_taken
      expect(white_king.first_move?).to be(false)
    end
  end

  describe '#all_king_move' do
    let(:board) { Board.new }
    context 'with a white king' do
      context 'in square 7,4' do
        it 'returns correct moves' do
          white_king = King.new(:white, 7,4)
          result = white_king.all_king_moves
          expect(result).to eq([[6, 5], [6, 3], [6, 4], [7, 3], [7, 5]])
        end
      end
      
      context 'in square 7,7' do
        it 'returns correct moves' do
          white_king = King.new(:white, 7,7)
          result = white_king.all_king_moves
          expect(result).to eq([[6, 6], [6, 7], [7, 6]])
        end
      end
      
      context 'in square 7,0' do
        it 'returns correct moves' do
          white_king = King.new(:white, 7,0)
          result = white_king.all_king_moves
          expect(result).to eq([[6, 1], [6, 0], [7, 1]])
        end
      end
    end
    
    context 'with a black king' do
      context 'in square 0,0' do
        it 'returns correct moves' do
          black_king = King.new(:black, 0,0)
          result = black_king.all_king_moves
          expect(result).to eq([[1, 1], [1, 0], [0, 1]])
        end
      end
      
      context 'in square 0,7' do
        it 'returns correct moves' do
          black_king = King.new(:black, 0,7)
          result = black_king.all_king_moves
          expect(result).to eq([[1, 6], [1, 7], [0, 6]])
        end
      end
      
      context 'in square 4,4' do
        it 'returns correct moves' do
          black_king = King.new(:black, 4,4)
          result = black_king.all_king_moves
          expect(result).to eq([[5, 5], [5, 3], [3, 5], [3, 3], [3, 4], [5, 4], [4, 3], [4, 5]])
        end
      end
    end
  end
end