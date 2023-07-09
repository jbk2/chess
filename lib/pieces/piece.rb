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
      # print(" |\u{26AB}#{self.class::WHITE_CHAR}#{self.class.to_s.chr}| ")
      # self.class
      self.class::WHITE_CHAR
    else
      # print(" |\u{26AA}#{self.class::BLACK_CHAR}#{self.class.to_s.chr}| ")
      # self.class
      self.class::BLACK_CHAR
    end
  end

  def move_path_clear?(move, board)
    puts "*** THE MOVE A #{move}"
    src_r, src_c, dst_r, dst_c = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i 
    puts "src_r = #{src_r}"
    puts "src_c = #{src_c}"
    puts "dst_r = #{dst_r}"
    puts "dst_c = #{dst_c}"
    
    neighbouring_squares = [[src_r+1, src_c+1], [src_r+1, src_c-1], [src_r-1, src_c-1], [src_r-1, src_c+1],
    [src_r-1, src_c],[src_r+1, src_c],[src_r, src_c-1],[src_r, src_c+1]].delete_if {|sq| sq.any? {|e| e < 0 || e > 7}} 
    return true if neighbouring_squares.include?([dst_r, dst_c]) && !src_dst_same_colour?(move, board)
      # return true
    # end
    # checks for nil values between paths
    if src_r < dst_r && src_c == dst_c # down
      (src_r+1...dst_r).each { |e| return false unless board.piece(e, src_c).nil? }
    elsif src_r > dst_r && src_c == dst_c # up
      (dst_r+1...src_r).each { |e| return false unless board.piece(e, src_c).nil? }
    elsif src_r == dst_r && src_c > dst_c # left
      (dst_c+1...src_c).each { |e| return false unless board.piece(src_r, e).nil? }
    elsif src_r == dst_r && src_c < dst_c # right
      (src_c+1...dst_c).each { |e| return false unless board.piece(src_r, e).nil? }
    elsif src_r < dst_r && src_c < dst_c # down right
      puts " \e[34m*************\e[0m #{(src_r+1...dst_r).zip(src_c+1...dst_c)}"
      (src_r+1...dst_r).zip(src_c+1...dst_c).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_r < dst_r && src_c > dst_c # down left
      (src_r+1...dst_r).zip((dst_c+1...src_c).to_a.reverse).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_r > dst_r && src_c < dst_c # up right
      (dst_r+1...src_r).to_a.reverse.zip(src_c+1...dst_c).each { |e| return false unless board.piece(e[0], e[1]).nil? }
    elsif src_r > dst_r && src_c > dst_c # up left
      puts "*** THE MOVE B #{move}"
      puts "*******heres the up left #{(dst_r+1...src_r).zip(dst_c+1...src_c)}"
      
      (dst_r+1...src_r).zip(dst_c+1...src_c)
      (dst_r+1...src_r).zip(dst_c+1...src_c).each { |e| return false unless board.piece(e[0], e[1]).nil?  }
    end
    return true
  end

  def src_dst_same_colour?(move, board)
    src_r, src_c, dst_r, dst_c = move[0].to_i, move[1].to_i, move[2].to_i, move[3].to_i 
    if board.piece(dst_r, dst_c) && (board.piece(dst_r, dst_c).colour == board.piece(src_r, src_c).colour)
      return true
    end
    false
  end

  def moves_into_check?(move)
    
  end

end