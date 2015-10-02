require 'byebug'



class Minesweeper

  MOVES = [
    ( 1, 1),
    (-1,-1),
    ( 1,-1),
    (-1, 1),
    ( 0, 1),
    ( 0,-1),
    ( 1, 0),
    (-1, 0)
  ]


  def initialize
    @board=Board.new


  end

  def reveal(pos) #pos = x, y
    self.board[pos].reveal
  end

  def flag_bomb(pos)
    self.board[pos].flag
  end

  def neighbors(pos)
    new_coord = []

    MOVES.each do |diff|
      new_coord << [pos[0] + diff[0], pos[1] + diff[1] ]
    end

    new_coord.select {|x| x[0].between?(0, self.board.length - 1) && x[1].between?(0, self.board.length - 1) }
    neighbors = []
    new_coord.each { |pos| neighbors << self.board[pos] }
    neighbors
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

  BOARD_SIZE = 9

  attr_accessor :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE) {Tile.new}}

    until self.grid.flatten.count{|x| x.bombed == true} == 10
      x,y = rand(self.grid.length), rand(self.grid.length)
      pos = [x,y]
      self[pos].bombed = true
    end

  end

  def [](pos)
    row, col = pos[0], pos[1]
    self.grid[row][col]
  end


  # def []=(pos, value)
  #   row, col = pos[0], pos[1]
  #   self.grid[row][col] = value
  # end


  def render

  end


end

if $PROGRAM_NAME == __FILE__
  a= Board.new
end
