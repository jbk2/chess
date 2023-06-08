class Player
  attr_accessor :name, :colour
  
  def initialize(name)
    @name = name
    @first_move = true
  end

  def first_move?
    @first_move
  end
  
  def first_move_made
    @first_move = false
  end

  private
 
end