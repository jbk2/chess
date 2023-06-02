class Player
  attr_accessor :name, :colour
  
  def initialize(name)
    @name = name
    @moves = []
  end

  def add_move(move)
    @moves << move
  end
  
  def moves
    @moves
  end

  def last_move
    moves.last
  end

end