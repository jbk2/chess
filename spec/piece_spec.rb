Dir[File.join('..', '/lib/pieces' '*.rb')].each { |file| require_relative file }
require_relative '../lib/board'

describe Piece do
  # example piece moves do not comply with piece move rules, purely tests #move_path_clear?()
  describe '#move_path_clear?(move)' do
    let(:pawn) { Pawn.new(:black, 2, 0) }
    let(:rook) { Rook.new(:black, 0, 0) }
    let(:board) { Board.new }
    context 'when move path is clear' do
      it 'returns true with a neigbouring square move' do
        result = pawn.move_path_clear?('2030', board)
        expect(result).to be(true)
      end
      
      it "returns true with straight move down and no pieces inbetween" do
        result = pawn.move_path_clear?('2040', board)
        expect(result).to be(true)
      end
      
      it "returns true with a straight up move of 3 squares and no pieces inbetween" do
        result = pawn.move_path_clear?('6030', board)
        expect(result).to be(true)
      end
      
      it "returns true with a left move of 3 squares and no pieces inbetween" do
        result = pawn.move_path_clear?('5350', board)
        expect(result).to be(true)
      end
    
      it "returns true with a right move of 4 squares and no pieces inbetween" do
        result = pawn.move_path_clear?('5054', board)
        expect(result).to be(true)
      end
      
      it "returns true with a down right move of 3 squares and no pieces inbetween" do
        result = pawn.move_path_clear?('2053', board)
        expect(result).to be(true)
      end
    
      it "returns true with a down left move of 4 squares and no pieces inbetween" do
        result = pawn.move_path_clear?('1753', board)
        expect(result).to be(true)
      end
    
      it "returns true with an up right move of 4 squares and no pieces inbetween" do
        result = pawn.move_path_clear?('6226', board)
        expect(result).to be(true)
      end
    
      it "returns true with an up left move of 4 squares and no pieces inbetween" do
        result = pawn.move_path_clear?('6723', board)
        expect(result).to be(true)
      end
    end
    
    context 'when move path is not clear' do
      it "returns false with a down move of 2 squares and a piece inbetween" do
        result = rook.move_path_clear?('0020', board)
        expect(result).to be(false)
      end
     
      it "returns false with an up move of 3 squares with a piece inbetween" do
        board.grid[5][0] = Pawn.new(:white, 5, 0)
        result = pawn.move_path_clear?('7040', board)
        expect(result).to be(false)
      end
      
      it "returns false with a left move of 3 squares with pieces inbetween" do
        result = pawn.move_path_clear?('6360', board)
        expect(result).to be(false)
      end
      
      it "returns false with a right move of 4 squares with pieces inbetween" do
        result = rook.move_path_clear?('7074', board)
        expect(result).to be(false)
      end

      it "returns false with a down right move of 3 squares with pieces inbetween" do
        board.grid[3][1] = Pawn.new(:white, 3, 1)
        board.grid[4][2] = Pawn.new(:white, 4, 2)
        result = pawn.move_path_clear?('2053', board)
        expect(result).to be(false)
      end

      it "returns false with a down left move of 4 squares with pieces inbetween" do
        board.grid[2][6] = Pawn.new(:white, 2, 6)
        board.grid[4][4] = Pawn.new(:white, 4, 4)
        result = pawn.move_path_clear?('1753', board)
        expect(result).to be(false)
      end

      it "returns false with up right move of 4 squares with pieces inbetween" do
        board.grid[4][4] = Pawn.new(:white, 4, 4)
        board.grid[3][5] = Pawn.new(:white, 3, 5)
        result = pawn.move_path_clear?('6226', board)
        expect(result).to be(false)
      end

      it "returns false with up left move of 4 squares and pieces inbetween" do
        board.grid[5][6] = Pawn.new(:white, 5, 6)
        board.grid[4][5] = Pawn.new(:white, 4, 5)
        board.grid[2][3] = Pawn.new(:white, 2, 3)
        result = pawn.move_path_clear?('6723', board)
        expect(result).to be(false)
      end
    end
  end

  describe "#src_dst_same_colour?(move)" do
    let(:board) { Board.new }
    it 'returns true when dst same colour as src' do
      black_rook = Rook.new(:black, 0,0)
      move = '0010'
      result = black_rook.src_dst_same_colour?(move, board)
      expect(result).to be(true)
    end
    
    it 'returns false when dst different colour to src' do
      black_pawn = Pawn.new(:black, 1,0)
      move = '1060'
      result = black_pawn.src_dst_same_colour?(move, board)
      expect(result).to be(false)
    end
    
    it "returns false when dst doesn't contain a piece" do
      black_pawn = Pawn.new(:black, 1,0)
      move = '1020'
      result = black_pawn.src_dst_same_colour?(move, board)
      expect(result).to be(false)
    end
  end
end