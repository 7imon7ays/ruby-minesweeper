class Square
  def initialize(coords)
    @x, @y = coords
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

  def find_children_squares
  end

end
