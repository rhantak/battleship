require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require 'pry'

binding.pry

@game = Game.new

@game.start_game
