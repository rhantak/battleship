require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'
class Game
  attr_reader :player_board, :computer_board

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
  end

  def start_game
    initial_input = nil
    until initial_input == "q"
      p "Welcome to BATTLESHIP"
      p "Enter 'p' to play. Enter 'q' to quit."
      valid_input = false

      until valid_input
        initial_input = gets.chomp
        if initial_input.downcase == "p"
          valid_input = true
          play_game
        elsif initial_input.downcase == "q"
          valid_input = true
        else p "That was not a valid input. Enter 'p' to play. Enter 'q' to quit."
        end
      end
    end
  end

  def play_game

    @computer_board
  end

  def computer_place_ships
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_sub = Ship.new("Submarine", 2)
    @cruiser_coordinates = []
      until @computer_board.valid_placement?(@computer_cruiser, @cruiser_coordinates)
        @cruiser_coordinates = @computer_board.cells.keys.sample(3)
      end
    @sub_coordinates = []
      until @computer_board.valid_placement?(@computer_sub, @sub_coordinates)
        @sub_coordinates = @computer_board.cells.keys.sample(2)
      end

    @computer_board.place(@computer_cruiser, @cruiser_coordinates)
    @computer_board.place(@computer_sub, @sub_coordinates)
    @computer_board.render_board(true)
  end

end


# @game = Game.new
# binding.pry
