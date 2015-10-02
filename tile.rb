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
