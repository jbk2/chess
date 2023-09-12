class Player
  attr_accessor :name, :colour
  attr_writer :first_move
  
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

  def to_json_data
    {
      'name' => @name,
      'first_move' => @first_move,
      'colour' => @colour
    }
  end

  def self.from_json_data(data)
    player = Player.new(data['name'])
    player.colour = data['colour'].to_sym
    player.first_move = data['first_move']
    player
  end

end