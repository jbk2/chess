class Player
  attr_accessor :name, :colour
  
  def initialize(name)
    @name = name
    @moves = []
  end

  def add_move(move)
    if move_valid_format?(move)
      true_move?(move) ? @moves << move : (raise InvalidInputError, "Input; #{move} does not represent an actual move")
    else
      raise InvalidInputError, "Input format should be 'rc,rc'"
    end
  end
  
  def moves
    @moves
  end

  def last_move
    moves.last
  end

  private
  def move_valid_format?(move)
    move.match?(/[a-h][1-8],[a-h][1-8]/) && move.length == 5
  end

  def true_move?(move)
    move[0..1] != move[3..4]
  end
end

class InvalidInputError < StandardError

  def initialize(message = 'Invalid input format')
    super(message)
  end

end