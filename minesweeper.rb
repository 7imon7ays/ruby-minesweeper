class Square
  attr_reader :coords, :mark
  attr_accessor :neighbors

  def initialize(coords)
    @coords = coords
    @x, @y = @coords
    @bomb = false
    @mark = '*'
    @neighbors = []
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
      coords_array.first.between?(0, 8) && coords_array.last.between?(0, 8)
    end

  end

end


class Board
  attr_reader :squares, :positions

  def initialize(dimension)
    set_positions(dimension)
    make_squares
    get_all_neighbors
  end

  def set_positions(dimension)
    @dimension = dimension
    @positions = []
    @dimension.times do |x|
      @dimension.times do |y|
        @positions << [x, y]
      end
    end
    positions
  end

  def make_squares
    @squares = @positions.map {|pos| Square.new(pos)}
  end

  def get_all_neighbors
    @squares.each do |square|
      square.neighbors = generate_neighbors(square)
    end
  end

  def generate_neighbors(square)
    neighbors = []
    adjacent_coords = square.find_adjacent_coords
    @squares.each do |other_square|
      adjacent_coords.each do |coord|
        neighbors << other_square if coord == other_square.coords
      end
    end

    neighbors
  end

  def get_input
    puts "Enter coordinates. To reveal or flag a square prefix coordinates with -r or -f, respectively."
    input = gets.chomp.split(" ")
  end

  def evaluate(input)
    chosen_coordinates = input[1..2]
    action = input[0]

    chosen_square = @square.select{|square| square.coords == chosen_coordinates}.flatten

    if action == "r"
      reveal(chosen_square)
    else
      toggle_flag(chosen_square)
    end
  end

  def toggle_flag(square)
    square.mark = square.mark == "f" ? "*" : "f"
    render
    check_for_win
  end

  def reveal(square)


    render
  end

  def mark_as_empty(square)
    square.mark = "_"
  end

  def render
    row = Hash.new([])
    @squares.each_with_index do |square, index|
      row[index % @dimension] += ["|#{square.mark}|"]
    end
    row.each {|key, value| puts value.join(" ")}
  end

  def check_for_win
    bomb_squares = @squares.select {|square| square.bomb}
    if bomb_squares.all?(square.mark == "f")
      abort( "You win!" )
    end
  end

end




board = Board.new(9)

# p board.render

# p board.squares
#p board.squares
# p board.squares[0].neighbors




