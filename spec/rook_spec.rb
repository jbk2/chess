require_relative '../lib/pieces/rook'
require_relative '../lib/board'
require_relative '../lib/game'

describe Rook do
  before do
    allow($stdin).to receive(:gets).and_return("new game pls", "John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep) # stubs any #sleep's for test running speed
  end

  describe "a Rook's instantiation" do
    it 'sets and makes readable colour, r, c and first_movevariables' do
      white_rook = Rook.new(:white, 0,0)
      rooks_colour = white_rook.colour
      rooks_x_coor = white_rook.r
      rooks_y_coor = white_rook.c
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

  describe '#every_rook_move' do
    context 'with a rook in position 0,0' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 0,0)
        result = white_rook.every_rook_move
        expect(result).to eq([[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
          [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]])
      end
    end

    context 'with a rook in position 0,7' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 0,7)
        result = white_rook.every_rook_move
        expect(result).to eq([[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6],
          [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]])
      end
    end
    
    context 'with a rook in position 7,0' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 7,0)
        result = white_rook.every_rook_move
        expect(result).to eq([[7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7],
          [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]])
      end
    end
    
    context 'with a rook in position 7,7' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 7,7)
        result = white_rook.every_rook_move
        expect(result).to eq([[7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6],
          [0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7]])
      end
    end
    
    context 'with a rook in position 3,3' do
      it 'returns all correct possible piece moves on an 8x8 board' do
        white_rook = Rook.new(:white, 3,3)
        result = white_rook.every_rook_move
        expect(result).to eq([[3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7], 
          [0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3]])
      end
    end
  end

  describe '#valid_rook_moves' do
    let(:board) { Board.new }
    context 'with a white rook in position 7,0 on starting board' do
      it 'returns all valid moves' do
        white_rook = Rook.new(:white, 7,0)
        board.grid[7][0] = white_rook
        src = [white_rook.r, white_rook.c]
        result = white_rook.valid_rook_moves(src, board)
        expect(result).to eq([])
      end
    end
    
    context 'with a white rook in position 5,0 on a starting board' do
      it 'returns all valid moves' do
        white_rook = Rook.new(:white, 5,0)
        board.grid[5][0] = white_rook
        src = [white_rook.r, white_rook.c]
        result = white_rook.valid_rook_moves(src, board)
        expect(result).to eq([[5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], [1, 0], [2, 0], [3, 0], [4, 0]])
      end
    end
    
    context 'with a white rook in position 1,0 on a starting board' do
      it 'returns all valid moves' do
        white_rook = Rook.new(:white, 1,0)
        board.grid[1][0] = white_rook
        src = [white_rook.r, white_rook.c]
        result = white_rook.valid_rook_moves(src, board)
        expect(result).to eq([[1, 1], [0, 0], [2, 0], [3, 0], [4, 0], [5, 0]])
      end
    end
    
    context 'with a black rook in position 4,3, and an own piece in 4,5, on a starting board' do
      it 'returns all valid moves' do
        black_rook = Rook.new(:black, 4, 3)
        board.grid[4][3] = black_rook
        black_pawn = Pawn.new(:black, 4, 5)
        board.grid[4][5] = black_pawn
        src = [black_rook.r, black_rook.c]
        result = black_rook.valid_rook_moves(src, board)
        expect(result).to eq([[4, 0],[4, 1],[4, 2],[4, 4], [2, 3], [3, 3], [5, 3], [6, 3]])
      end
    end
    
    context 'with a black rook in position 5,2, an opponent pawn in 3,2 & 5,5, on a starting board' do
      it 'returns all valid moves' do
        black_rook = Rook.new(:black, 5, 2)
        board.grid[5][2] = black_rook
        white_pawn = Pawn.new(:white, 3, 2)
        board.grid[3][2] = white_pawn
        white_pawn = Pawn.new(:white, 5, 5)
        board.grid[5][5] = white_pawn
        src = [black_rook.r, black_rook.c]
        result = black_rook.valid_rook_moves(src, board)
        expect(result).to eq([[5, 0], [5, 1], [5, 3], [5, 4], [5, 5], [3, 2], [4, 2], [6, 2]])
      end
    end
  end

  describe "#valid_move?(move, board)" do
    let(:game) { Game.new }
    context "when move is valid against piece, game and board rules" do
      it "returns true" do
        game.board.grid[6][0] = nil
        white_rook = game.board.piece(7, 0)
        move = '7020'
        result = white_rook.valid_move?(move, game.board)
        expect(result).to be(true)
      end
      
      it "returns true" do
        game.board.grid[5][4] = Rook.new(:white, 5, 4)
        white_rook = game.board.piece(5, 4)
        move = '5424'
        result = white_rook.valid_move?(move, game.board)
        expect(result).to be(true)
      end
    end
    
    context "when move is not valid against piece, game and board rules" do
      it "returns false" do
        white_rook = game.board.piece(7, 0)
        move = '7060'
        result = white_rook.valid_move?(move, game.board)
        expect(result).to be(false)
      end

      it "returns false" do
        game.board.grid[5][4] = Rook.new(:white, 5, 4)
        white_rook = game.board.piece(5, 4)
        move = '5432'
        result = white_rook.valid_move?(move, game.board)
        expect(result).to be(false)
      end
    end
  end
 
end