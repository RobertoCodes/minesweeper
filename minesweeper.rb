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

  def initialize
    @revealed = false
    @bombed = false
    @flagged = false
  end

  def inspect
    p "Bomb at #{}"
  end

  def reveal
    self.revealed = true
  end

  def flag
    self.flagged = true
  end

end

class Board

  BOARD_SIZE = 9

  def initialize
    @grid = Array.new(BOARD_SIZE) {Array.new(grid_SIZE)}

    self.grid.each do |row|
      row.each do |column|
        self[row,column] = Tile.new      #######
      end
    end

    until self.grid.flatten.count{|x| x.bombed == true}
      x,y = rand(self.grid.length), rand(self.grid.length)
      self[x, y].bombed = true
    end

  end

  def []=(x, y)
    self.grid[x][y]
  end



end
