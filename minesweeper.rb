require 'byebug'
require_relative 'board.rb'
require_relative 'tile.rb'



class Minesweeper

  attr_accessor :board, :checked_tiles

  def initialize
    @board=Board.new
    @checked_tiles = []
  end

  def over?
    return true if won?
    self.board.tiles.any? {|x| x.bombed? && x.revealed?}
  end

  def won?
    self.board.tiles.select {|x| !x.bombed?}.all? {|y| y.revealed?}
  end

  def explore(tile)
    return if tile.neighbor_bomb_count > 0
    tile.neighbors.reject { |tile| self.checked_tiles.include?(tile) }.each do |neighbor_tile|
      self.checked_tiles << neighbor_tile
      neighbor_tile.revealed = true
      explore(neighbor_tile)
    end
  end

  def play_turn
    input = get_input
    unless input.include?("F")
      pos = input.map(&:to_i)
      tile = @board[pos]
      check_move(tile)
      self.checked_tiles << tile
      tile.revealed = true
      tile.flagged = false
      return "You lose! " if tile.bombed?
      explore(tile)
    end

    if input.include?("F")
      pos = input[1..2].map(&:to_i)
      tile = @board[pos]
      check_move(tile)
      tile.flagged = true
    end

  end

  # def valid_input?(input)
  #   return false unless input.count.between?(2,3)
  #   if input.count == 2
  #     return false if !input[0].between?(0,self.board.grid.length-1) &&
  #     !input[1].between?(0,self.board.grid.length-1)
  #   elsif input.count == 3
  #     return false if !input[1].between?(0,self.board.grid.length-1) &&
  #     !input[2].between?(0,self.board.grid.length-1)
  #   else
  #     return false if input[0] != "F"
  #   end
  #   true
  # end

  def check_move(tile)
    if self.checked_tiles.include?(tile)
      puts "Already revealed position"
      play_turn
    end
  end

  def run
    until over?
      self.board.render
      play_turn
    end
    reveal_all
    self.board.render
    if won?
      puts "congratulations! you won!"
    else
      puts "you lose!"
    end
  end

  def reveal_all
    self.board.grid.each do |row|
      row.each do |tile|
        tile.revealed = true
      end
    end
  end

  def get_input
    input = []
    puts "Please enter a coordinate "
    puts "Place F in front for a flag"
    puts "Examples: 0,0     1,1       3,7"
    puts "Examples: F,0,0     F,1,1       F,3,7"
    input = gets.chomp.split(",")

  end

end


if $PROGRAM_NAME == __FILE__
  a= Minesweeper.new.run
end
