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
  
  before do 
    board.populate_board
  end

  it "can build a board with Pawn pieces in correct location" do
    board.grid[1].each do |e|
      expect(e).to be_instance_of(Pawn)
    end 
    board.grid[6].each do |e|
      expect(e).to be_instance_of(Pawn)
    end 
  end

  it '#populate_board populates grid with the correct pieces in correct positions' do
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
  
  it 'can return a piece from a given location in the grid' do
    piece = board.piece(1,0) 
    expect(piece).to be_instance_of(Pawn)
  end
  
  it 'has pieces whose x and y values mirror the grid position' do
    piece = board.piece(1,0)
    expect(piece.x).to eq(1)
    expect(piece.y).to eq(0)
  end

  it 'a board can tell the colour of its pieces' do
    black_rook = board.piece(0,0)
    white_bishop = board.piece(7,1)
    expect(black_rook.colour).to eq(:black)
    expect(white_bishop.colour).to eq(:white)
  end
  
end