class InputError < StandardError

  def initialize(message = 'Input error')
    super(message)
  end

end