class Game
  attr_reader :live_cells, :tick_count

  def initialize(live_cells)
    @tick_count = 0
    @live_cells = live_cells # Arr[ [x,y] ]
  end

  def tick(args=nil)
    calculate_next_gen
    render(args)
    @tick_count += 1
  end

  def trigger_cell(x,y)
    cell = [x,y]
    if live_cells.include? cell
      live_cells.delete(cell)
    else
      live_cells << cell
    end
  end

  private

  attr_writer :live_cells, :tick_count

  def calculate_next_gen
    next_gen_living_cells = []
    live_cell_map = convert_cells_to_map

    cells_to_check = calculate_cells_to_check

    cells_to_check.each do |x,y|
      is_next_gen_living = check_cell(x,y,live_cell_map)
      next_gen_living_cells << [x,y] if is_next_gen_living
    end
    @live_cells = next_gen_living_cells
  end

  def check_cell(x,y,live_cell_map)
    adjacent_living_cell_count = adjacent_living_cell_count(x,y,live_cell_map)

    return true if adjacent_living_cell_count == 3
    return true if adjacent_living_cell_count == 2 && is_living_cell?(x,y,live_cell_map)

    return false
  end

  def is_living_cell?(x,y,live_cell_map)
    live_cell_map.dig(x)&.dig(y) == true
  end

  def convert_cells_to_map
    map = {}
    live_cells.each do |x,y|
      map[x] ||= {}
      map[x][y] = true
    end

    map
  end

  def calculate_cells_to_check
    cells_to_check = live_cells.dup

    live_cells.each do |x,y|
      cells_to_check += adjacent_cell_coordinates(x,y)
    end

    cells_to_check.uniq
  end

  def adjacent_cell_coordinates(x,y)
    adjacent_cells = []

    -1.upto(1).each do |i|
      -1.upto(1).each do |j|
        adjacent_cells << [x+i,y+j]
      end
    end
    adjacent_cells -= [[x,y]]

    adjacent_cells
  end

  def adjacent_living_cell_count(x,y,live_cell_map)
    map = live_cell_map
    count = 0
    -1.upto(1).each do |i|
      -1.upto(1).each do |j|
        next if i==0 && j==0

        count += 1 if map.dig(x+i)&.dig(y+j)
      end
    end

    count
  end

  def render(args)
    # print_console
  end

  def print_console
    puts "--- Round #{tick_count} ---"

    max_x = live_cells.map{|x,y| x}.max + 5
    max_y = live_cells.map{|x,y| y}.max + 5

    max_y.times do |y|
      max_x.times do |x|
        if live_cells.include? [x,y]
          print "*"
        else
          print "."
        end
      end
      print "\n"
    end
  end
end

# console test

# INPUT = [
#   [9,9],
#   [10,10],
#   [9,11],
#   [11,11],
#   [9,12],
#   [11,12],
#   [13,13],
#   [14,13],
#   [15,13],
#   [16,13],
#   [16,15],
#   [16,16],
#   [17,17],
# ]

# game = Game.new(INPUT)

# 100.times do |i|
#   game.tick

#   sleep 0.2
# end