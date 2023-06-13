require_relative '../lib/pieces/pawn'
require_relative '../lib/board'

describe Pawn do
  describe "a pawn's instantiation" do
    it 'sets and makes readable colour, x, y and first_movevariables' do
      white_pawn = Pawn.new(:white, 6,0)
      pawns_colour = white_pawn.colour
      pawns_x_coor = white_pawn.x
      pawns_y_coor = white_pawn.y
      pawns_first_move = white_pawn.first_move?
      expect(pawns_colour).to equal(:white)
      expect(pawns_x_coor).to equal(6)
      expect(pawns_y_coor).to equal(0)
      expect(pawns_first_move).to be(true)
    end
  end

  describe '#first_move_taken' do
    it "sets pawn's @first move to false" do
      white_pawn = Pawn.new(:white, 6,0)
      expect(white_pawn.first_move?).to be(true)
      white_pawn.first_move_taken
      expect(white_pawn.first_move?).to be(false)
    end
  end

  describe '#valid_pawn_move' do
    let(:board) { Board.new }
    context 'with a white pawn' do
      context 'in square 6,0' do
        it 'returns correct moves' do
          white_pawn = Pawn.new(:white, 6,0)
          result = white_pawn.valid_pawn_moves(board)
          expect(result).to eq([[5, 0], [4, 0]])
        end
      end
      
      context 'in square 4,0' do
        it 'returns correct moves' do
          white_pawn = Pawn.new(:white, 4,0)
          allow(white_pawn).to receive(:first_move?).and_return(false)
          result = white_pawn.valid_pawn_moves(board)
          expect(result).to eq([[3, 0]])
        end
      end
      
      context 'in square 6,0' do
        it 'returns correct moves' do
          white_pawn = Pawn.new(:white, 3,7)
          allow(white_pawn).to receive(:first_move?).and_return(false)
          result = white_pawn.valid_pawn_moves(board)
          expect(result).to eq([[2, 7]])
        end
      end

      context 'with a taking move option' do
        context 'in square 2,1' do
          it 'returns correct moves' do
            white_pawn = Pawn.new(:white, 2,1)
            allow(white_pawn).to receive(:first_move?).and_return(false)
            result = white_pawn.valid_pawn_moves(board)
            expect(result).to eq([[1, 0], [1, 2]])
          end
        end
        
        context 'in square 4,4 with opponent pieces in 3,3 & 3,5' do
          it 'returns correct moves' do
            baord = Board.new
            white_pawn = Pawn.new(:white, 4, 4)
            board.grid[4][4] = white_pawn
            board.grid[3][3] = Bishop.new(:black, 3, 3)
            board.grid[3][5] = Knight.new(:black, 3, 5)
            allow(white_pawn).to receive(:first_move?).and_return(false)
            result = white_pawn.valid_pawn_moves(board)
            expect(result).to eq([[3, 4], [3, 3], [3, 5]])
          end
        end
      end
    end
    
    context 'with a black pawn' do
      context 'in square 1,7' do
        it 'returns correct moves' do
          black_pawn = Pawn.new(:black, 1,7)
          allow(black_pawn).to receive(:first_move?).and_return(false)
          result = black_pawn.valid_pawn_moves(board)
          expect(result).to eq([[2, 7]])
        end
      end
      
      context 'in square 3,3' do
        it 'returns correct moves' do
          black_pawn = Pawn.new(:black, 3,3)

          allow(black_pawn).to receive(:first_move?).and_return(false)
          result = black_pawn.valid_pawn_moves(board)
          expect(result).to eq([[4, 3]])
        end
      end
      
      context 'in square 5,7' do
        it 'returns correct moves' do
          black_pawn = Pawn.new(:black, 5,7)
          allow(black_pawn).to receive(:first_move?).and_return(false)
          result = black_pawn.valid_pawn_moves(board)
          expect(result).to eq([[6, 6]])
        end
      end

      context 'with a taking move option' do
        context 'in square 5,2' do
          it 'returns correct moves' do
            black_pawn = Pawn.new(:black, 5,2)
            allow(black_pawn).to receive(:first_move?).and_return(false)
            result = black_pawn.valid_pawn_moves(board)
            expect(result).to eq([[6, 1], [6, 3]])
          end
        end
        
        context 'in square 3,2 with an opponent piece in 4,1' do
          it 'returns correct moves' do
            black_pawn = Pawn.new(:black, 3,2)
            board = Board.new
            board.grid[4][1] = Queen.new(:white, 4, 1)
            allow(black_pawn).to receive(:first_move?).and_return(false)
            result = black_pawn.valid_pawn_moves(board)
            expect(result).to eq([[4, 2], [4, 1]])
          end
        end
        
        context 'in square 3,2 with opponent pieces in 4,1 & 4,3' do
          it 'returns correct moves' do
            black_pawn = Pawn.new(:black, 3,2)
            board = Board.new
            board.grid[4][1] = Queen.new(:white, 4, 1)
            board.grid[4][3] = Bishop.new(:white, 4, 3)
            allow(black_pawn).to receive(:first_move?).and_return(false)
            result = black_pawn.valid_pawn_moves(board)
            expect(result).to eq([[4, 2], [4, 1], [4, 3]])
          end
        end
      end
    end
  end
end