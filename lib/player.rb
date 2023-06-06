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
      raise InvalidInputError, "Move should move position, and when placed in Person.moves array formatted like 'iiii'"
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
    move.match?(/[0-7][0-7][0-7][0-7]/) && move.length == 4
  end

  def true_move?(move)
    move[0..1] != move[2..3]
  end
end

class InvalidInputError < StandardError

  def initialize(message = 'Invalid input format')
    super(message)
  end

end