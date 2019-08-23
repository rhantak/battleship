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
    quit = nil
    until quit == "q"
      p "Welcome to BATTLESHIP"
      p "Enter 'p' to play. Enter 'q' to quit."
      valid_input = false
      until valid_input
        initial_input = gets.chomp
        if initial_input.downcase == "p"
          valid_input = true
          play_game()
        elsif initial_input.downcase == "q"
          valid_input = true
          quit = "q"
        else p "That was not a valid input. Enter 'p' to play. Enter 'q' to quit."
        end
      end
    end
  end

  def play_game
    computer_place_cruiser
    computer_place_sub
    @cruiser = Ship.new("Cruiser", 3)
    @sub = Ship.new("Submarine", 2)

    puts "Your opponent has laid out their ships on the grid."
    puts "You now need to place your two ships."
    puts "The Cruiser is 3 units long and the Submarine is 2 units long."
    print @player_board.render_board(true)
    puts "Enter the squares for your Cruiser (3 spaces) separated by spaces"
    puts "Example: A1 A2 A3"

    good_cruiser = false
    until good_cruiser
      print "> "
      cruiser_spaces = gets.chomp
      cruiser_array = cruiser_spaces.split(" ").to_a
      if @player_board.valid_placement?(@cruiser, cruiser_array)
        good_cruiser = true
        @player_board.place(@cruiser, cruiser_array)
      else
        puts "That's an invalid placement shipmate, please try again."
      end
    end

    print @player_board.render_board(true)
    puts "Enter the squares for your Submarine (2 spaces)"

    good_sub = false
    until good_sub
      print "> "
      sub_spaces = gets.chomp
      sub_array = sub_spaces.split(" ").to_a
      if @player_board.valid_placement?(@sub, sub_array)
        good_sub = true
        @player_board.place(@sub, sub_array)
      else
        puts "That's an invalid placement shipmate, please try again."
      end
    end
  end

  def computer_place_cruiser
    @computer_cruiser = Ship.new("Cruiser", 3)
    @cruiser_coordinates = ["A1", "B2", "C3"]
    until @computer_board.valid_placement?(@computer_cruiser, @cruiser_coordinates) == true
      @cruiser_coordinates = @computer_board.cells.keys.sample(3)
    end
    @computer_board.place(@computer_cruiser, @cruiser_coordinates)
  end

  def computer_place_sub
    @computer_sub = Ship.new("Submarine", 2)
    @sub_coordinates = ["A1", "A3"]
    until @computer_board.valid_placement?(@computer_sub, @sub_coordinates) == true
      @sub_coordinates = @computer_board.cells.keys.sample(2)
    end
    @computer_board.place(@computer_sub, @sub_coordinates)
  end
end


@game = Game.new
binding.pry
