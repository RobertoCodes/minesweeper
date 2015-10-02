require 'byebug'



class Minesweeper

  attr_accessor :board, :checked_tiles

  def initialize
    @board=Board.new
    @checked_tiles = []
  end

  def reveal(pos) #pos = x, y
    self.board[pos].reveal
  end

  def flag_bomb(pos)
    self.board[pos].flag
  end

  def play_turn
    pos = get_input
    tile = @board[pos]
    if self.checked_tiles.include?(tile)
      puts "Already revealed position"
      play_turn
    end
    self.checked_tiles << tile
    tile.revealed = true
    return "You lose! " if tile.bombed?
    explore(tile)
  end

  def run
    until over?
      self.board.render
      play_turn
    end
    if won?
      puts "congratulations! you won!"
    else
      puts "you lose!"
    end

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

  def to_s
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

if $PROGRAM_NAME == __FILE__
  a= Minesweeper.new.run
end
