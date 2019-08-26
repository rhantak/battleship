require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require 'pry'



@game = Game.new
@game.player_create_ships
@game.player_place_ships
# binding.pry
