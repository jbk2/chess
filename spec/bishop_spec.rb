require_relative '../lib/pieces/bishop'
require_relative '../lib/board'

describe Bishop do
  describe "a bishop's instantiation" do
    it 'sets and makes readable colour, r, c and first_move variables' do
      white_bishop = Bishop.new(:white, 0,2)
      bishops_colour = white_bishop.colour
      bishops_x_coor = white_bishop.r
      bishops_y_coor = white_bishop.c
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

  describe '#every_bishop_move' do
    context 'with a bishop in square 0,2' do
      it 'returns all correct possible piece moves' do
        white_bishop = Bishop.new(:white, 0,2)
        result = white_bishop.every_bishop_move
        expect(result).to include([1, 3], [2, 4], [3, 5], [4, 6], [5, 7], [1, 1], [2, 0])
      end
    end
    
    context 'with a bishop in square 4,3' do
      it 'returns all correct possible piece moves' do
        white_bishop = Bishop.new(:white, 4,3)
        result = white_bishop.every_bishop_move
        expect(result).to include([5, 4], [6, 5], [7, 6], [3, 4], [2, 5], [1, 6], [0, 7],
          [3, 2], [2, 1], [1, 0], [5, 2], [6, 1], [7, 0])
      end
    end
    
    context 'with a bishop in square 3,3' do
      it 'returns all correct possible piece moves' do
        white_bishop = Bishop.new(:white, 3,3)
        result = white_bishop.every_bishop_move
        expect(result).to include([4, 4], [5, 5], [6, 6], [4, 2], [5, 1], [6, 0],
          [2, 4], [1, 5], [0, 6], [2, 2], [1, 1], [0, 0])
      end
    end
   
    context 'with a bishop in square 2,5' do
      it 'returns all correct possible piece moves' do
        white_bishop = Bishop.new(:white, 2,5)
        result = white_bishop.every_bishop_move
        expect(result).to include([3,6], [4,7], [3,4], [4,3], [5, 2], [6, 1],
          [7, 0], [1, 6], [0, 7], [1, 4], [0, 3])
      end
    end
    
    context 'with a bishop in square 5,3' do
      it 'returns all correct possible piece moves' do
        white_bishop = Bishop.new(:white, 5,3)
        result = white_bishop.every_bishop_move
        expect(result).to include([6, 4], [7, 5], [6, 2], [7, 1], [4, 4], [3, 5],
          [2, 6], [1, 7], [4, 2], [3, 1], [2, 0])
      end
    end
  end

  describe '#valid_bishop_moves(src, board)' do
    let(:board) { Board.new }
    context 'with a white bishop in position 5,2 on a starting board' do
      it 'returns all valid moves' do
        white_bishop = Bishop.new(:white, 5,2)
        board.grid[5][2] = white_bishop
        src = [white_bishop.r, white_bishop.c]
        result = white_bishop.valid_bishop_moves(src, board)
        expect(result).to eq([[4, 3],[3, 4],[2, 5],[1, 6],[4, 1],[3, 0]])
      end
    end
    
    context 'with a white bishop in position 5,2, white pawn in 3,4, on a starting board' do
      it 'returns all correct valid piece moves' do
        white_bishop, white_pawn = Bishop.new(:white, 5,2), Pawn.new(:white, 3,4)
        board.grid[5][2], board.grid[3][4] = white_bishop, white_pawn
        src = [white_bishop.r, white_bishop.c]
        result = white_bishop.valid_bishop_moves(src, board)
        expect(result).to eq([[4, 3],[4, 1],[3, 0]])
      end
    end
    
    context 'with a white bishop in position 5,2, black pawn in 3,4, on a starting board' do
      it 'returns all correct valid piece moves' do
        white_bishop, black_pawn = Bishop.new(:white, 5,2), Pawn.new(:black, 3,4)
        board.grid[5][2], board.grid[3][4] = white_bishop, black_pawn
        src = [white_bishop.r, white_bishop.c]
        result = white_bishop.valid_bishop_moves(src, board)
        expect(result).to eq([[4, 3],[3, 4], [4, 1],[3, 0]])
      end
    end
    
    context 'with a white bishop in position 1,2 on a starting board' do
      it 'returns all correct valid piece moves' do
        white_bishop = Bishop.new(:white, 1,2)
        board.grid[1][2] = white_bishop
        src = [white_bishop.r, white_bishop.c]
        result = white_bishop.valid_bishop_moves(src, board)
        expect(result).to eq([[2, 3], [3, 4], [4, 5], [5, 6], [2, 1], [3, 0], [0, 3], [0, 1]])
      end
    end
    
    context 'with a white bishop in position 7,2 on a starting board' do
      it 'returns all correct valid piece moves' do
        white_bishop = board.piece(7, 2)
        src = [white_bishop.r, white_bishop.c]
        result = white_bishop.valid_bishop_moves(src, board)
        expect(result).to eq([])
      end
    end
    
    context 'with a black bishop in position 7,2 on a starting board' do
      it 'returns all correct valid piece moves' do
        black_bishop = Bishop.new(:black, 7, 2)
        board.grid[7][2] = black_bishop
        src = [black_bishop.r, black_bishop.c]
        result = black_bishop.valid_bishop_moves(src, board)
        expect(result).to eq([[6, 3], [6, 1]])
      end
    end
  end
end