class Game
  attr_reader :map, :round

  def initialize(max_x,max_y,input)
    @map = []
    @max_x = max_x
    @max_y = max_y
    @round = 0

    max_x.times do |i|
      col = []
      max_y.times do |j|
        if input.include? [i,j]
          col << 1
        else
          col << 0
        end
      end
      map << col
    end
  end

  def tick
    @round += 1
    calculate

    return map
  end

  private

  attr_reader :max_x, :max_y

  def calculate
    new_map = []
    max_x.times do |x|
      col = []
      max_y.times do |y|
        new_cell_value = check_cell(x,y,map)
        col << new_cell_value
      end
      new_map << col
    end
    @map = new_map
  end

  def check_cell(x,y,map)
    adjacent_count =  cell_value(map,x+1,y+1) +
                      cell_value(map,x+1,y) +
                      cell_value(map,x+1,y-1) +
                      cell_value(map,x,y+1) +
                      cell_value(map,x,y-1) +
                      cell_value(map,x-1,y+1) +
                      cell_value(map,x-1,y) +
                      cell_value(map,x-1,y-1)

    is_live_cell = map[x][y] == 1

    if is_live_cell
      return adjacent_count == 2 || adjacent_count == 3 ? 1 : 0
    else # dead_cell
      return adjacent_count == 3 ? 1 : 0
    end
  end

  def cell_value(map,x,y)
    return 0 if x > max_x - 1 || x < 0
    return 0 if y > max_y - 1 || y < 0

    map[x][y]
  end

  def print_map
    puts "\n--- the map ---"
    max_y.times do |y|
      max_x.times do |x|
        char = map[x][y] == 1 ? "#" : "."
        print char
      end
      print "\n"
    end
  end

end

MAX_X = 40
MAX_Y = 24

BLOCK_SIZE = (1280/MAX_X).round

INPUT = [
  [9,9],
  [10,10],
  [9,11],
  [11,11],
  [9,12],
  [11,12],
  [13,13],
  [14,13],
  [15,13],
  [16,13],
  [16,15],
  [16,16],
  [17,17],
]

SPEED = 0.3 # every second
TICK_FOR_STEP = (SPEED * 60).round

def tick args

  args.outputs.labels  << [640, 500, 'Conways game of life', 5, 1]
  # args.outputs.labels  << [640, 460, 'Go to docs/docs.html and read it!', 5, 1]
  # args.outputs.labels  << [640, 420, 'Join the Discord! https://discord.dragonruby.org', 5, 1]
  # args.outputs.sprites << [576, 280, 128, 101, 'dragonruby.png']
  game = args.state.game
  if game.nil?
    game = Game.new(MAX_X,MAX_Y,INPUT)
    args.state.game = game
  end

  args.outputs.solids << [
    0, 
    0,   
    MAX_X*BLOCK_SIZE,     
    MAX_Y*BLOCK_SIZE,   
    164,   
    212,    
    220,   
    128]

  if args.state.tick_count % TICK_FOR_STEP == 0
    game.tick
  end

  MAX_X.times do |x|
    MAX_Y.times do |y|
      live_cell = game.map[x][y] == 1 ? true : false
      args.outputs.solids << [
        x*BLOCK_SIZE, 
        y*BLOCK_SIZE,   
        BLOCK_SIZE,     
        BLOCK_SIZE,   
        219, 
        163, 
        211,
        255] if live_cell
    end
  end

  args.outputs.labels  << [640, 600, "Round ##{game.round}", 5, 1]
  # args.outputs.labels  << [640, 700, "Tick count ##{args.state.tick_count}", 5, 1]
  # args.outputs.labels << [10, 710, "framerate: #{args.gtk.current_framerate.round}"]


  # render
  #  X    Y  WIDTH  HEIGHT  RED  GREEN  BLUE  ALPHA

end