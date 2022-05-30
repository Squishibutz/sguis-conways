require 'app/game.rb'

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

SPEED = 0.05 # every second
TICK_FOR_STEP = (SPEED * 60).round


def tick args
  args.outputs.labels  << [640, 500, 'Conways game of life', 5, 1]
  # args.outputs.labels  << [640, 460, 'Go to docs/docs.html and read it!', 5, 1]
  # args.outputs.labels  << [640, 420, 'Join the Discord! https://discord.dragonruby.org', 5, 1]
  # args.outputs.sprites << [576, 280, 128, 101, 'dragonruby.png']
  game = args.state.game
  if game.nil?
    game = Game.new(INPUT)
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

  live_cells = game.live_cells
  live_cells.each do |x,y|
    args.outputs.solids << [
      x*BLOCK_SIZE, 
      y*BLOCK_SIZE,   
      BLOCK_SIZE,     
      BLOCK_SIZE,   
      219, 
      163, 
      211,
      255]
  end

  args.outputs.labels  << [640, 600, "Round ##{game.tick_count}", 5, 1]
  args.outputs.labels  << [640, 700, "Tick count ##{args.state.tick_count}", 5, 1]
  args.outputs.labels << [10, 710, "framerate: #{args.gtk.current_framerate.round}"]


  # render
  #  X    Y  WIDTH  HEIGHT  RED  GREEN  BLUE  ALPHA

end