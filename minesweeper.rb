require 'byebug'



class Minesweeper

  attr_accessor :board

  def initialize
    @board=Board.new
  end

  def reveal(pos) #pos = x, y
    self.board[pos].reveal
  end

  def flag_bomb(pos)
    self.board[pos].flag
  end

  def play_turn
    pos = get_input
    @board[pos].revealed = true

  end


  def get_input
    puts "Please enter a coordinate "
    puts "Examples: 0,0     1,1       3,7"
    gets.chomp.split(",").map(&:to_i)
  end




end




class Tile

  MOVES = [
    [ 1, 1],
    [-1,-1],
    [ 1,-1],
    [-1, 1],
    [ 0, 1],
    [ 0,-1],
    [ 1, 0],
    [-1, 0]
  ]

  attr_accessor :bombed, :flagged, :revealed, :bombed
  attr_reader :board

  def initialize(board)
    @revealed = false
    @bombed = false
    @flagged = false
    @board = board
  end

  def inspect
    if self.flagged?
      "F"
    elsif !self.revealed?
      "*"
    elsif self.bombed?
      "O"
    elsif self.neighbor_bomb_count != 0
      "#{neighbor_bomb_count}"
    else
      "_"
    end
  end

  def revealed?
    self.revealed
  end

  def flagged?
    self.flagged
  end

  def bombed?
    self.bombed
  end

  def set_bomb
    self.bombed = true
  end

  def neighbors
    new_coord = []
    pos = self.board.find_position(self)


    MOVES.each do |diff|
      new_coord << [pos[0] + diff[0], pos[1] + diff[1] ]
    end

    new_coord.select! {|x| x[0].between?(0, self.board.grid.length - 1) && x[1].between?(0, self.board.grid.length - 1) }
    neighbors = []
    new_coord.each { |pos| neighbors << self.board[pos] }
    neighbors
  end

  def neighbor_bomb_count
    neighbors.count{|x| x.bombed == true}
  end

end



class Board

  BOARD_SIZE = 9

  attr_accessor :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) {Tile.new(self)} }

    until tiles.count { |x| x.bombed? } == 10
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

if $PROGRAM_NAME == __FILE__
  a= Board.new
end
