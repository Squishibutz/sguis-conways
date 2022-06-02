require 'app/game.rb'

MAX_X = 64
MAX_Y = 39

BLOCK_SIZE = (1280/MAX_X).round

INPUT = [
  [31,23],
  [31,24],
  [32,23],
  [31,25],
  [33,24]
]

SPEED = 0.05 # every second
TICK_FOR_STEP = (SPEED * 60).round


def tick args
  # INIT
  args.state.paused = true if args.state.paused.nil?

  game = args.state.game
  if game.nil?
    game = Game.new(INPUT)
    args.state.game = game
  end

  # HANDLE Inputs
  if args.inputs.keyboard.key_up.space
    args.state.paused = !args.state.paused
  end

  # GAME LOOP
  if !args.state.paused
    # continue ticks if unpaused
    if args.state.tick_count % TICK_FOR_STEP == 0
      game.tick
    end
  else
    #paused
    args.outputs.labels  << [640, 40, "Game is paused. Press <space> to continue", 4, 1]

    # allows adding new cells
    if args.inputs.mouse.click
      x = (args.inputs.mouse.click.point.x / BLOCK_SIZE).floor
      y = (args.inputs.mouse.click.point.y / BLOCK_SIZE).floor
      game.trigger_cell(x,y)
    end
  end

  # RENDER
  args.outputs.labels  << [1160, 710, "Round ##{game.tick_count}"]
  #args.outputs.labels << [10, 710, "framerate: #{args.gtk.current_framerate.round}"]
  args.outputs.labels  << [640, 710, 'Conways game of life', 5, 1]

  # draw BG
  args.outputs.solids << [
    0, 
    0,   
    MAX_X*BLOCK_SIZE,     
    MAX_Y*BLOCK_SIZE,   
    164,   
    212,    
    220,   
    128]

  # draw the cells
  live_cells = game.live_cells
  args.outputs.solids << live_cells.map do |x,y|
    [x*BLOCK_SIZE, 
      y*BLOCK_SIZE,   
      BLOCK_SIZE,     
      BLOCK_SIZE,   
      219, 
      163, 
      211,
      255]
  end
end