class Board

  BOARD_SIZE = 9

  NUM_BOMBS = 10

  attr_reader :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) {Tile.new(self)} }

    until tiles.count { |x| x.bombed? } == NUM_BOMBS
      x,y = rand(self.grid.length), rand(self.grid.length)
      pos = [x,y]
      self[pos].set_bomb
    end

  end

  def [](pos)
    row, col = pos[0], pos[1]
    self.grid[row][col]
  end

  def find_position(tile)
    x,y = nil,nil
    self.grid.each {|row| x= self.grid.index(row) if row.include?(tile)}
    y = self.grid[x].index(tile)
    [x,y]
  end

  def tiles
    self.grid.flatten
  end


  # def []=(pos, value)
  #   row, col = pos[0], pos[1]
  #   self.grid[row][col] = value
  # end

  def render
    system("clear")
    puts "  #{(0...self.grid.length).to_a.join("  ")}"
    self.grid.each_with_index do |row, i|
      p "#{i} #{row.each(&:inspect).join("  ")}"
    end
  end

end
