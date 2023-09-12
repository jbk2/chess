require_relative '../lib/pieces/knight'
require_relative '../lib/game'

describe Knight do
  describe "a knight's instantiation" do
    it 'sets and makes readable colour, r, c and first_movevariables' do
      white_knight = Knight.new(:white, 3,3)
      knights_colour = white_knight.colour
      knights_x_coor = white_knight.r
      knights_y_coor = white_knight.c
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


  describe "#every_knight_move" do
    context 'with a knight inå 3,3' do
      it 'has 8 L shaped possible moves' do
        white_knight = Knight.new(:white, 3,3)
        result = white_knight.every_knight_move
        moves_array = [[5, 4],[5, 2],[1, 4],[1, 2],[4, 5],[2, 5],[4, 1],[2, 1]]
        expect(result).to eq(moves_array)
      end
    end
    
    context 'with a knight in 2,5' do
      it 'has 8 L shaped possible moves' do
        white_knight = Knight.new(:white, 2,5)
        result = white_knight.every_knight_move
        moves_array = [[4, 6],[4, 4],[0, 6],[0, 4],[3, 7],[1, 7],[3, 3],[1, 3]]
        expect(result).to eq(moves_array)
      end
    end
    
    context 'with a knight in 0,0' do
      it "gives the only two in board bounds possible moves" do
        black_knight = Knight.new(:black, 0,0)
        result = black_knight.every_knight_move
        moves_array = [[2, 1],[1, 2]]
        expect(result).to eq(moves_array)    
      end
    end
    
    context 'with a knight in 0,6' do
      it "gives the only two in board bounds possible moves" do
        black_knight = Knight.new(:black, 0,6)
        result = black_knight.every_knight_move
        moves_array = [[2, 7],[2, 5], [1, 4]]
        expect(result).to eq(moves_array)    
      end
    end
    
    context 'with a knight in 0,1' do
      it "gives the only two in board bounds possible moves" do
        black_knight = Knight.new(:black, 0,1)
        result = black_knight.every_knight_move
        moves_array = [[2, 2],[2, 0], [1, 3]]
        expect(result).to eq(moves_array)    
      end
    end
  end

  describe '#valid_move?(move, board)' do
    let(:black_knight) {Knight.new(:black, 0,1)}
    let(:board) { Board.new }
    context "when move meets knight's rules" do
      context "is in board bounds" do
        it 'returns true' do
          expect(black_knight.valid_move?('0122', board)).to be(true)
        end
        it 'returns true' do
          expect(black_knight.valid_move?('0120', board)).to be(true)
        end
        context "has own piece in dst" do
          it 'returns false' do
            expect(black_knight.valid_move?('0113', board)).to be(false)
          end
        end
      end
      context "is out of board bounds" do
        it 'returns false' do
          expect(black_knight.valid_move?('01-1-1', board)).to be(false)
        end
        
        it 'returns false' do
          expect(black_knight.valid_move?('01-2-2', board)).to be(false)
        end
      end
    end

    context "when move doesn't meet knight's rules" do
      context "but is in board bounds" do
        it 'returns false' do
          expect(black_knight.valid_move?('0132', board)).to be(false)
        end

        it 'returns false' do
          expect(black_knight.valid_move?('0114', board)).to be(false)
        end
      end
    end
  end

  describe '#valid_knight_moves(src, board)' do
    let(:board) { Board.new }
    context 'with a white_knight in 3, 3 on a starting board' do 
      it 'returns all valid piece moves' do
        white_knight = Knight.new(:white, 3, 3)
        board.grid[3][3] = white_knight
        src = [white_knight.r, white_knight.c]
        result = white_knight.valid_knight_moves(src, board)
        expect(result).to eq([[5, 4], [5, 2], [1, 4], [1, 2], [4, 5], [2, 5], [4, 1], [2, 1]])
      end
    end
    
    context 'with a white_knight in 5, 3 on a starting board' do 
      it 'returns all valid piece moves' do
        white_knight = Knight.new(:white, 5, 3)
        board.grid[5][3] = white_knight
        src = [white_knight.r, white_knight.c]
        result = white_knight.valid_knight_moves(src, board)
        expect(result).to eq([[3, 4], [3, 2], [4, 5], [4, 1]])
      end
    end
    
    context 'with a white_knight in 5, 3, black pawn in 4, 5, on a starting board' do 
      it 'returns all valid piece moves' do
        white_knight, black_pawn = Knight.new(:white, 5, 3), Pawn.new(:black, 4, 5)
        board.grid[5][3], board.grid[4][5] = white_knight, black_pawn
        src = [white_knight.r, white_knight.c]
        result = white_knight.valid_knight_moves(src, board)
        expect(result).to eq([[3, 4], [3, 2], [4, 5], [4, 1]])
      end
    end
    
    context 'with a white_knight in 5, 3, white pawn in 4, 5, on a starting board' do 
      it 'returns all valid piece moves' do
        white_knight, white_pawn = Knight.new(:white, 5, 3), Pawn.new(:white, 4, 5)
        board.grid[5][3], board.grid[4][5] = white_knight, white_pawn
        src = [white_knight.r, white_knight.c]
        result = white_knight.valid_knight_moves(src, board)
        expect(result).to eq([[3, 4], [3, 2], [4, 1]])
      end
    end
    
    # context 'with a white_knight in 0, 6 on a starting board' do 
    #   it 'returns all valid piece moves' do
    #     white_knight, white_pawn = Knight.new(:white, 0, 6), Pn.new(:white, 4, 5)
    #     board.grid[5][3], board.grid[4][5] = white_knight, white_pawn
    #     src = [white_knight.r, white_knight.c]
    #     result = white_knight.valid_knight_moves(src, board)
    #     expect(result).to eq([[3, 4], [3, 2], [4, 1]])
    #   end
    # end
    
    context 'with a black_knight in 0, 1 on a starting board' do 
      it 'returns all valid piece moves' do
        black_knight = Knight.new(:black, 0, 1)
        board.grid[0][1] = black_knight
        src = [black_knight.r, black_knight.c]
        result = black_knight.valid_knight_moves(src, board)
        expect(result).to eq([[2, 2], [2, 0]])
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
        white_knight = game.board.piece(7, 1)
        move = '7152'
        result = white_knight.valid_move?(move, game.board)
        expect(result).to be(true)
      end

      it "returns true" do
        game.board.grid[5][0] = Pawn.new(:black, 5, 0)
        white_knight = game.board.piece(7, 1)
        move = '7150'
        result = white_knight.valid_move?(move, game.board)
        expect(result).to be(true)
      end

      it "returns true" do
        game.board.grid[7][1], game.board.grid[6][1], game.board.grid[4][3], game.board.grid[3][3] = nil, nil, Knight.new(:white, 4, 3), Knight.new(:black, 3, 3)
        white_knight = game.board.piece(4, 3)
        move = '4324'
        result = white_knight.valid_move?(move, game.board)
        expect(result).to be(true)
      end
    end
  
    context "when move is not valid against piece, game and board rules" do
      it "returns false" do
        white_knight = game.board.piece(7, 1)
        move = '7163'
        result = white_knight.valid_move?(move, game.board)
        expect(result).to be(false)
      end
      
      it "returns false" do
        game.board.grid[7][4], game.board.grid[6][4] = nil, nil
        game.board.grid[5][2] = Pawn.new(:white, 5, 2)
        white_knight = game.board.piece(7, 1)
        move = '7152'
        result = white_knight.valid_move?(move, game.board)
        expect(result).to be(false)
      end
    end
  end

  # test updating the objects x&y during a move

end