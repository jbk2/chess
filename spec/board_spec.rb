require_relative '../lib/board'

describe Board do
  let(:board) {Board.new}
  
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
      
      it "the returned piece's x and y values match the grid position looked up" do
        piece = board.piece(1,0)
        expect(piece.x).to eq(1)
        expect(piece.y).to eq(0)
      end
    end

    context 'with invalid coordinates' do
      it 'raises and InputErrorprints a message describing the error' do
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
  
end