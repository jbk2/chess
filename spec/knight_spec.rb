require_relative '../lib/pieces/knight'

describe Knight do
  describe "a knight's instantiation" do
    it 'sets and makes readable colour, x, y and first_movevariables' do
      white_knight = Knight.new(:white, 3,3)
      knights_colour = white_knight.colour
      knights_x_coor = white_knight.x
      knights_y_coor = white_knight.y
      knights_first_move = white_knight.first_move?
      expect(knights_colour).to equal(:white)
      expect(knights_x_coor).to equal(3)
      expect(knights_y_coor).to equal(3)
      expect(knights_first_move).to be(true)
    end
  end

  describe '#first_move_taken' do
    it "sets Knight's @first move to false" do
      white_knight = Knight.new(:white, 3,3)
      expect(white_knight.first_move?).to be(true)
      white_knight.first_move_taken
      expect(white_knight.first_move?).to be(false)
    end
  end


  describe "#all_knight_moves" do
    context 'with a knight in coords 3,3' do
      it 'has 8 L shaped possible moves' do
        white_knight = Knight.new(:white, 3,3)
        result = white_knight.all_knight_moves
        moves_array = [[5, 4],[5, 2],[1, 4],[1, 2],[4, 5],[2, 5],[4, 1],[2, 1]]
        expect(result).to eq(moves_array)
      end
    end
    
    context 'with a knight in coords 2,5' do
      it 'has 8 L shaped possible moves' do
        white_knight = Knight.new(:white, 2,5)
        result = white_knight.all_knight_moves
        moves_array = [[4, 6],[4, 4],[0, 6],[0, 4],[3, 7],[1, 7],[3, 3],[1, 3]]
        expect(result).to eq(moves_array)
      end
    end
    
    context 'with a knight in 0,0 coords' do
      it "gives the only two in board bounds possible moves" do
        black_knight = Knight.new(:black, 0,0)
        result = black_knight.all_knight_moves
        moves_array = [[2, 1],[1, 2]]
        expect(result).to eq(moves_array)    
      end
    end
  end

  describe '#piece_valid_move?(move, board)' do
    let(:black_knight) {Knight.new(:black, 0,1)}
    let(:board) { Board.new }
    context "when move meets knight's rules and is in board bounds" do
      it 'returns true' do
        expect(black_knight.piece_valid_move?('0122', board)).to be(true)
      end
      
      it 'returns true' do
        expect(black_knight.piece_valid_move?('0120', board)).to be(true)
      end
      
      it 'returns true' do
        expect(black_knight.piece_valid_move?('0113', board)).to be(true)
      end
    end
    
    context "when move doesn't meet knight's rules but is in board bounds" do
      it 'returns false' do
        expect(black_knight.piece_valid_move?('0132', board)).to be(false)
      end
      
      it 'returns false' do
        expect(black_knight.piece_valid_move?('0114', board)).to be(false)
      end
    end
    
    context "when does meet knight's rules but is out of board bounds" do
      it 'returns false' do
        expect(black_knight.piece_valid_move?('01-1-1', board)).to be(false)
      end
      
      it 'returns false' do
        expect(black_knight.piece_valid_move?('01-2-2', board)).to be(false)
      end
    end
  end

  # test updating the objects x&y during a move

end