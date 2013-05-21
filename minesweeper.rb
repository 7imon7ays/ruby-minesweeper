class Square
  attr_reader :coords
  attr_accessor :neighbors, :mark, :bomb

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
    place_bombs
    get_all_neighbors
    @start_time = Time.new
    play
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

  def place_bombs
    bomb_coords = generate_bomb_coords
    @squares.each do |square|
       square.bomb = true if bomb_coords.include?(square.coords)
    end
  end


  def generate_bomb_coords
    bomb_positions = []
    until bomb_positions.count == 10
      x = rand(@dimension)
      y = rand(@dimension)
      pos = [x, y]
      next if bomb_positions.include?(pos)
      bomb_positions << pos
    end
    bomb_positions
  end


  def play
    render

    current_time = Time.new

    time_elapsed = current_time - @start_time

    puts "Time elapsed: #{time_elapsed.to_i} seconds"

    input = get_input

    if input.join == "save"
      puts "Name your saved file."
      file_name = gets.chomp
      File.open(file_name, "w"), self.to_json

    evaluate(input)

    while true
      play
    end
  end

  def get_input
    puts "Enter coordinates. To reveal or flag a square prefix coordinates with -r or -f, respectively."
    input = gets.chomp.split(" ")
  end

  def evaluate(input)

    chosen_coordinates = input[1..2].map(&:to_i)
    action = input[0]
    p action
    p input

    chosen_square = @squares.select{|square|
      # p "FOUND #{square.coords}" if square.coords == chosen_coordinates
      square.coords == chosen_coordinates}.last

    if action == "r"
      reveal(chosen_square)
    else
      toggle_flag(chosen_square)
    end
  end

  def toggle_flag(square)
    square.mark = square.mark == "F" ? "*" : "F"
    check_for_win
    play
  end

  def reveal(square)
    if square.bomb
      square.mark = "@"
      render
      abort("You lose sucka")
    end

    num_adj_bombs = count_adjacent_bombs(square)

    if num_adj_bombs == 0
      square.mark = "_"
      auto_check(square)
    else
       square.mark = num_adj_bombs.to_s
    end
  end

  def auto_check(square)
    neighbors = square.neighbors
    neighbors.each do |neighbor|
      next unless neighbor.mark == "*"
      p "currently inspecting square #{neighbor.coords.inspect}"
      reveal(neighbor)
    end
  end

  def count_adjacent_bombs(square)
    count = 0
    square.neighbors.each do |neighbor|
      count +=1 if neighbor.bomb
    end
    count
  end

  def mark_as_empty(square)
    square.mark = "_"
  end

  def render
    row = Hash.new([])
    @squares.each_with_index do |square, index|
      row[index % @dimension] += ["|#{square.mark}|"]
    end
    (0...@dimension).each {|x_coord| print "   #{x_coord}"}
    puts
    row.each {|key, value| puts "#{key} #{value.join(" ")}"}
  end

  def check_for_win
    bomb_squares = @squares.select {|square| square.bomb}
    if bomb_squares.all?{|square| square.mark == "f"}
      abort( "You win!" )
    end
  end

end




board = Board.new(16)
