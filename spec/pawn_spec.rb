require_relative '../lib/pieces/pawn'
require_relative '../lib/board'
require_relative '../lib/game'

describe Pawn do
  describe "a pawn's instantiation" do
    it 'sets and makes readable colour, r, c and first_movevariables' do
      white_pawn = Pawn.new(:white, 6,0)
      pawns_colour = white_pawn.colour
      pawns_x_coor = white_pawn.r
      pawns_y_coor = white_pawn.c
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

  describe '#valid_pawn_moves(src, board)' do
    let(:board) { Board.new }
    context 'with a white pawn' do
      context 'in square 6,0' do
        it 'returns correct moves' do
          white_pawn = Pawn.new(:white, 6,0)
          src = [white_pawn.r, white_pawn.c]
          result = white_pawn.valid_pawn_moves(src, board)
          expect(result).to eq([[5, 0], [4, 0]])
        end
      end
      
      context 'in square 4,0' do
        it 'returns correct moves' do
          white_pawn = Pawn.new(:white, 4,0)
          src = [white_pawn.r, white_pawn.c]
          allow(white_pawn).to receive(:first_move?).and_return(false)
          result = white_pawn.valid_pawn_moves(src, board)
          expect(result).to eq([[3, 0]])
        end
      end
      
      context 'in square 6,0' do
        it 'returns correct moves' do
          white_pawn = Pawn.new(:white, 3,7)
          src = [white_pawn.r, white_pawn.c]
          allow(white_pawn).to receive(:first_move?).and_return(false)
          result = white_pawn.valid_pawn_moves(src, board)
          expect(result).to eq([[2, 7]])
        end
      end

      context 'with a taking move option' do
        context 'in square 2,1' do
          it 'returns correct moves' do
            white_pawn = Pawn.new(:white, 2,1)
            src = [white_pawn.r, white_pawn.c]
            allow(white_pawn).to receive(:first_move?).and_return(false)
            result = white_pawn.valid_pawn_moves(src, board)
            expect(result).to eq([[1, 0], [1, 2]])
          end
        end
        
        context 'in square 4,4 with opponent pieces in 3,3 & 3,5' do
          it 'returns correct moves' do
            baord = Board.new
            white_pawn = Pawn.new(:white, 4, 4)
            src = [white_pawn.r, white_pawn.c]
            board.grid[4][4] = white_pawn
            board.grid[3][3] = Bishop.new(:black, 3, 3)
            board.grid[3][5] = Knight.new(:black, 3, 5)
            allow(white_pawn).to receive(:first_move?).and_return(false)
            result = white_pawn.valid_pawn_moves(src, board)
            expect(result).to eq([[3, 4], [3, 3], [3, 5]])
          end
        end
      end
    end
    
    context 'with a black pawn' do
      context 'in square 1,7' do
        it 'returns correct moves' do
          black_pawn = Pawn.new(:black, 1,7)
          src = [black_pawn.r, black_pawn.c]
          allow(black_pawn).to receive(:first_move?).and_return(false)
          result = black_pawn.valid_pawn_moves(src, board)
          expect(result).to eq([[2, 7]])
        end
      end
      
      context 'in square 3,3' do
        it 'returns correct moves' do
          black_pawn = Pawn.new(:black, 3,3)
          src = [black_pawn.r, black_pawn.c]
          allow(black_pawn).to receive(:first_move?).and_return(false)
          result = black_pawn.valid_pawn_moves(src, board)
          expect(result).to eq([[4, 3]])
        end
      end
      
      context 'in square 5,7' do
        it 'returns correct moves' do
          black_pawn = Pawn.new(:black, 5,7)
          src = [black_pawn.r, black_pawn.c]
          allow(black_pawn).to receive(:first_move?).and_return(false)
          result = black_pawn.valid_pawn_moves(src, board)
          expect(result).to eq([[6, 6]])
        end
      end

      context 'with a taking move option' do
        context 'in square 5,2' do
          it 'returns correct moves' do
            black_pawn = Pawn.new(:black, 5,2)
            src = [black_pawn.r, black_pawn.c]
            allow(black_pawn).to receive(:first_move?).and_return(false)
            result = black_pawn.valid_pawn_moves(src, board)
            expect(result).to eq([[6, 1], [6, 3]])
          end
        end
        
        context 'in square 3,2 with an opponent piece in 4,1' do
          it 'returns correct moves' do
            black_pawn = Pawn.new(:black, 3,2)
            src = [black_pawn.r, black_pawn.c]
            board = Board.new
            board.grid[4][1] = Queen.new(:white, 4, 1)
            allow(black_pawn).to receive(:first_move?).and_return(false)
            result = black_pawn.valid_pawn_moves(src, board)
            expect(result).to eq([[4, 2], [4, 1]])
          end
        end
        
        context 'in square 3,2 with opponent pieces in 4,1 & 4,3' do
          it 'returns correct moves' do
            black_pawn = Pawn.new(:black, 3,2)
            src = [black_pawn.r, black_pawn.c]
            board = Board.new
            board.grid[4][1] = Queen.new(:white, 4, 1)
            board.grid[4][3] = Bishop.new(:white, 4, 3)
            allow(black_pawn).to receive(:first_move?).and_return(false)
            result = black_pawn.valid_pawn_moves(src, board)
            expect(result).to eq([[4, 2], [4, 1], [4, 3]])
          end
        end
      end
    end
  end

  describe "#valid_move?(move, board)" do
    before do
      allow($stdin).to receive(:gets).and_return("new game pls", "John", "James")
      allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
      allow_any_instance_of(Game).to receive(:sleep) # stubs any #sleep's for test running speed
    end
    let(:game) { Game.new }

    context "when move is valid against piece, game and board rules" do
      it "returns true" do
        white_pawn = game.board.piece(6, 0)
        move = '6050'
        result = white_pawn.valid_move?(move, game.board)
        expect(result).to be(true)
      end
      
      it "returns true" do
        game.board.grid[5][1] = Queen.new(:black, 5, 1)
        white_pawn = game.board.piece(6, 0)
        move = '6051'
        result = white_pawn.valid_move?(move, game.board)
        expect(result).to be(true)
      end
      
      it "returns true" do
        black_pawn = game.board.piece(1, 7)
        move = '1727'
        result = black_pawn.valid_move?(move, game.board)
        expect(result).to be(true)
      end
    end
  
    context "when move is not valid against piece, game and board rules" do
      it "returns false" do
        white_pawn = game.board.piece(6, 0)
        move = '6051'
        result = white_pawn.valid_move?(move, game.board)
        expect(result).to be(false)
      end
      
      it "returns false" do
        game.board.grid[5][1] = Queen.new(:white, 5, 1)
        white_pawn = game.board.piece(6, 0)
        move = '6051'
        result = white_pawn.valid_move?(move, game.board)
        expect(result).to be(false)
      end
    end
  end

end