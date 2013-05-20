class Square
  attr_reader :coords

  def initialize(coords)
    @coords = coords
    @x, @y = @coords
    @bomb = false
    @mark = '*'
    @neighbors  = []
  end

  def find_adjacent_coords
    adjacent_coords = [
    [@x + 1, @y],
    [@x + 1, @y + 1],
    [@x + 1, @y - 1],
    [@x, @y + 1],
    [@x, @y - 1],
    [@x - 1, @y],
    [@x - 1, @y + 1],
    [@x - 1, @y - 1]
  ]

    adjacent_coords.select do |coords_array|
      coords_array.first.between?(0, 8) && coords_array.last.between?(0,8)
    end
  end

  # def find_children_squares(board_array)
 #    children_squares = []
 #    board_array.map {|object| object.coords} do |coord|
 #      children_squares << b if find_adjacent_coords.include?(coord)
 #  end
 #


end


class Board
  attr_reader :squares

  def initialize(dimension)
    @positions = []
    dimension.times do |x|
      dimension.times do |y|
        @positions << [x, y]
      end
    end

    @squares = @positions.map {|pos| Square.new(pos)}


  end

end

board = Board.new(9)
p board.squares.map(&:coords)

