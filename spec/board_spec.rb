require_relative '../lib/board'
require_relative '../lib/game'

describe Board do
  let(:board) {Board.new}
  # let(:game) {Game.new}
  before do
    allow($stdin).to receive(:gets).and_return("John", "James")
    allow($stdout).to receive(:write) # comment if debugging as this will stop pry output also 
    allow_any_instance_of(Game).to receive(:sleep) # stubs any #sleep's for test running speed
  end
  
  it 'has a grid with 8 rows' do
    row_count = board.grid.count
    expect(row_count).to eq(8)
  end
  
  it 'has a grid with 8 columns' do
    row_count = board.grid[0].count
    expect(row_count).to eq(8)
  end
  
  describe '#populate_board' do
    before do 
      board.populate_board
    end

    it "correctly populates board's @grid with every Pawn in starting positions" do
      board.grid[1].each do |e|
        expect(e).to be_instance_of(Pawn)
      end 
      board.grid[6].each do |e|
        expect(e).to be_instance_of(Pawn)
      end 
    end

    it "correctly populates board's @grid with all pieces in starting positions" do
      expect(board.grid[1][0]).to be_instance_of(Pawn)
      expect(board.grid[1][7]).to be_instance_of(Pawn)
      expect(board.grid[0][0]).to be_instance_of(Rook)
      expect(board.grid[7][7]).to be_instance_of(Rook)
      expect(board.grid[0][1]).to be_instance_of(Knight)
      expect(board.grid[7][6]).to be_instance_of(Knight)
      expect(board.grid[0][2]).to be_instance_of(Bishop)
      expect(board.grid[7][5]).to be_instance_of(Bishop)
      expect(board.grid[0][3]).to be_instance_of(Queen)
      expect(board.grid[7][3]).to be_instance_of(Queen)
      expect(board.grid[0][4]).to be_instance_of(King)
      expect(board.grid[7][4]).to be_instance_of(King)
    end 
  end

  describe '@colour_grid' do
    it 'has black squares in the correct locations' do
      expect(board.colour_grid[7][0]).to be(:black)
      expect(board.colour_grid[7][4]).to be(:black)
      expect(board.colour_grid[5][2]).to be(:black)
      expect(board.colour_grid[2][5]).to be(:black)
      expect(board.colour_grid[0][3]).to be(:black)
    end
    
    it 'has white squares in the correct locations' do
      expect(board.colour_grid[0][0]).to be(:white)
      expect(board.colour_grid[4][4]).to be(:white)
      expect(board.colour_grid[5][5]).to be(:white)
      expect(board.colour_grid[6][6]).to be(:white)
      expect(board.colour_grid[7][7]).to be(:white)
    end
  end

  describe '#piece' do
    context 'with valid coordinates' do
      it 'returns the piece from the given location in the grid' do
        piece = board.piece(1,0) 
        expect(piece).to be_instance_of(Pawn)
      end
      
      it "the returned piece's r and c values match the grid position looked up" do
        piece = board.piece(1,0)
        expect(piece.r).to eq(1)
        expect(piece.c).to eq(0)
      end
    end

    context 'with invalid coordinates' do
      it 'raises an InputError' do
        expect { board.piece(9,8) }.to raise_error(InputError, '9,8 is not a valid coordinate. Try again...')
      end
    end
  end

  describe 'board and piece colours' do
    it "a board can tell the colour of its pieces" do
      black_rook = board.piece(0,0)
      white_bishop = board.piece(7,1)
      expect(black_rook.colour).to eq(:black)
      expect(white_bishop.colour).to eq(:white)
    end

    it "a board can tell the colour of its squares"  do
      board.send(:build_colour_grid)
      expect(board.square_colour(7,0)).to eq(:black)
      expect(board.square_colour(0,0)).to eq(:white)
    end
  end

  describe '#opponent_piece?(r, c, colour)' do
    it 'returns true when a different colour piece resides in given square' do
      result = board.opponent_piece?(1, 0, :white)
      expect(result).to be(true)
    end
    
    it 'returns true when a different colour piece resides in given square' do
      result = board.opponent_piece?(7, 7, :black)
      expect(result).to be(true)
    end
    
    it 'returns false when a different colour piece resides in given square' do
      result = board.opponent_piece?(6, 0, :white)
      expect(result).to be(false)
    end
    
    it 'returns false when a different colour piece resides in given square' do
      result = board.opponent_piece?(0, 4, :black)
      expect(result).to be(false)
    end
  end

  describe '#empty_square?(r, c)' do
    it 'returns true if square is empty' do
      expect(board.empty_square?(2,0)). to be(true)
    end
    
    it 'returns false if square is occupied' do
      expect(board.empty_square?(1,0)). to be(false)
    end
  end
  
  describe '#valid_coord(r, c)' do
    it 'returns true if index value on an 8x8 grid' do
      expect(Board.valid_coord?(2,0)). to be(true)
    end
    
    it 'returns false if index value not on an 8x8 grid' do
      expect(Board.valid_coord?(8, 3)). to be(false)
    end
  end
    
  describe '#find_pieces(type, colour)' do
    context 'with white pieces' do
      it 'returns the position of the king' do
        game = Game.new
        result = board.find_pieces('king', game.active_player.colour)
        expect(result).to eq([[7, 4]])
      end
      
      it 'returns the position of the rooks' do
        game = Game.new
        result = board.find_pieces('rook', game.active_player.colour)
        expect(result).to eq([[7, 0], [7, 7]])
      end
    end
    
    context 'with black pieces' do
      it 'returns the position of the king' do
        game = Game.new
        game.send(:toggle_turn)
        result = board.find_pieces('king', game.active_player.colour)
        expect(result).to eq([[0, 4]])
      end
      
      it 'returns the position of the king for the given colour' do
        game = Game.new
        game.send(:toggle_turn)
        result = board.find_pieces('pawn', game.active_player.colour)
        expect(result).to eq([[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]])
      end
    end
  end

  describe '#all_pieces(colour)' do
    it 'returns all white pieces' do
      result = board.all_pieces(:white)
      pieces = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], [7, 0], [7, 7],
        [7, 1], [7, 6], [7, 2], [7, 5], [7, 3], [7, 4]]
      expect(result).to eq(pieces)
    end
    
    it 'returns all black pieces' do
      result = board.all_pieces(:black)
      pieces = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [0, 0], [0, 7],
        [0, 1], [0, 6], [0, 2], [0, 5], [0, 3], [0, 4]]
      expect(result).to eq(pieces)
    end
  end

end