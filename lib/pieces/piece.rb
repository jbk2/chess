require 'pry-byebug'

class Piece

  attr_reader :colour, :r, :c

  def initialize(colour, r, c)
    @colour = colour
    @r = r
    @c = c
  end

  def uni_char
    if colour == :white
      self.class::WHITE_CHAR
    else
      self.class::BLACK_CHAR
    end
  end

  def move_path_clear?(move, board)
    src_r, src_c, dst_r, dst_c = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i
    neighbouring_squares = [[src_r+1, src_c+1], [src_r+1, src_c-1], [src_r-1, src_c-1], [src_r-1, src_c+1],
    [src_r-1, src_c],[src_r+1, src_c],[src_r, src_c-1],[src_r, src_c+1]].delete_if {|sq| sq.any? {|e| e < 0 || e > 7}} 
    return true if neighbouring_squares.include?([dst_r, dst_c]) && !src_dst_same_colour?(move, board)
    
    # the below checks for nil values between paths
    if src_r < dst_r && src_c == dst_c # down
      (src_r+1...dst_r).each { |e| return false unless board.piece(e, src_c).nil? }
    elsif src_r > dst_r && src_c == dst_c # up
      (dst_r+1...src_r).each { |e| return false unless board.piece(e, src_c).nil? }
    elsif src_r == dst_r && src_c > dst_c # left
      (dst_c+1...src_c).each { |e| return false unless board.piece(src_r, e).nil? }
    elsif src_r == dst_r && src_c < dst_c # right
      (src_c+1...dst_c).each { |e| return false unless board.piece(src_r, e).nil? }
    elsif src_r < dst_r && src_c < dst_c # down right
      (src_r+1...dst_r).zip(src_c+1...dst_c).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_r < dst_r && src_c > dst_c # down left
      (src_r+1...dst_r).zip((dst_c+1...src_c).to_a.reverse).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_r > dst_r && src_c < dst_c # up right
      (dst_r+1...src_r).to_a.reverse.zip(src_c+1...dst_c).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_r > dst_r && src_c > dst_c # up left
      (dst_r+1...src_r).zip(dst_c+1...src_c).each { |e| return false unless board.piece(e[0], e[1]).nil?  }
    end
    return true
  end

  def src_dst_same_colour?(move, board)
    src_r, src_c, dst_r, dst_c = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i 
    return true if board.piece(dst_r, dst_c) && (board.piece(dst_r, dst_c).colour == board.piece(src_r, src_c).colour)
    false
  end

  def to_json_data
    {
      'class' => self.class.to_s,
      'first_move' => @first_move,
      'colour' => @colour,
      'r' => @r,
      'c' => @c
    }
  end

end