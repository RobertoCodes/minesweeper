require 'byebug'

class Minesweeper
  def initialize
    @board=Board.new


  end

  def reveal(pos) #pos = x, y
    self.board[pos].reveal
  end

  def flag_bomb(pos)
    self.board[pos].flag
  end

end


class Tile

  attr_accessor :bombed

  def initialize
    @revealed = false
    @bombed = false
    @flagged = false
  end
  #
  # def inspect
  #   p "Bomb at #{}"
  # end

  def reveal
    self.revealed = true
  end

  def flag
    self.flagged = true
  end

end

class Board

  attr_accessor :grid

  BOARD_SIZE = 9

  def initialize
    @grid = Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE) {Tile.new}}

    until self.grid.flatten.count{|x| x.bombed == true} == 10
      x,y = rand(self.grid.length), rand(self.grid.length)
      self[[x,y]].bombed = true
    end

  end

  def [](pos)
    row, col = pos[0], pos[1]
    self.grid[row][col]
  end


  def []=(pos, value)
    row, col = pos[0], pos[1]
    self.grid[row][col] = value
  end

  def render

  end


end

if $PROGRAM_NAME == __FILE__
  a= Board.new
end
