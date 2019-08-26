require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class Game
  attr_reader :player_board, :computer_board

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @player_ships = []
    @computer_ships = []
    #have different board classes for each respective size.
    # board_selection_verif = false
    # until board_selection_verif == true
    #   puts "How large of a playing field do you want?"
    #   puts "Board 1: 4x4"
    #   puts "Board 2: 6x6"
    #   puts "Board 3: 8x8"
    #   puts "Board 4: 10x10"
    #   puts "Enter the number of the board you'd like to play with."
    #   board_selection = gets.chomp.to_i
    #   if
    #     board_selection == 1
    #     @player_board = Board.new
    #     @computer_board = Board.new
    #     board_selection_verif = true
    #   elsif
    #     board_selection == 2
    #     @player_board = Board_2.new
    #     @computer_board = Board_2.new
    #     board_selection_verif = true
    #   elsif
    #     board_selection == 3
    #     @player_board = Board_3.new
    #     @computer_board = Board_3.new
    #     board_selection_verif = true
    #   elsif
    #     board_selection == 4
    #     @player_board = Board_4.new
    #     @computer_board = Board_4.new
    #     board_selection_verif = true
    #   else
    #     system "clear"
    #     puts "That is not a valid response. Please choose a number between 1 and 4"
    #     puts "========================================"
    #     puts "How large of a playing field do you want?"
    #     puts "Board 1: 4x4"
    #     puts "Board 2: 6x6"
    #     puts "Board 3: 8x8"
    #     puts "Board 4: 10x10"
    #     puts "Enter the number of the board you'd like to play with."
    #     board_selection = gets.chomp.to_i
        #have different board classes for each respective size.

  end

  #  def start_game
  #   quit = nil
  #   until quit == "q"
  #     p "Welcome to BATTLESHIP Comrade!"
  #     p "Enter 'p' to play. Enter 'q' to quit."
  #     valid_input = false
  #     until valid_input
  #       initial_input = gets.chomp
  #       if initial_input.downcase == "p"
  #         valid_input = true
  #         initialize()
  #         play_game()
  #       elsif initial_input.downcase == "q"
  #         valid_input = true
  #         quit = "q"
  #         return "Thanks for playing!"
  #       else p "That was not a valid input. Enter 'p' to play. Enter 'q' to quit."
  #       end
  #     end
  #   end
  # end

  # def play_game
  #   computer_place_cruiser
  #   computer_place_sub
  #   player_place_ships
  #   computer_loss = false
  #   player_loss = false
  #   until computer_loss || player_loss
  #     take_turn
  #     if @cruiser.sunk? && @computer_cruiser.sunk? && @sub.sunk? && @computer_sub.sunk?
  #       puts "You and your enemy sunk each other's last ship at the same time!"
  #       puts "Mutually assured destruction!"
  #     elsif @cruiser.sunk? && @sub.sunk?
  #       player_loss = true
  #       puts "The enemy sunk all your ships! A loss for the Motherland!"
  #       puts " "
  #       puts "=" * 40
  #       puts " "
  #     elsif @computer_cruiser.sunk? && @computer_sub.sunk?
  #       computer_loss = true
  #       puts "You sunk all your enemy's ships! A victory for the Motherland!"
  #       puts " "
  #       puts "=" * 40
  #       puts " "
  #     end
  #   end
  # end

#have every new ship be its own loop, so we can assign different instance variables to them.
  def player_create_ships
    puts "What ship should we add to our fleet comrade?"
    puts "(Some ship class and size suggestions, famous battleships)"
    puts " "
    print "> "
    new_ship_name = gets.chomp.to_s

    new_ship = false
    until new_ship
      if
        new_ship_name.length >= 3
        new_ship = true
      else
        puts "Try naming it something else"
        print "> "
        new_ship_name = gets.chomp.to_s
      end
    end

      puts "How large should our ship be?"
      puts "> "
      new_ship_size = gets.chomp.to_i
      new_ship_size_validation = false
    until new_ship_size_validation == true
       if
        new_ship_size.is_a? Integer
        new_ship_size_validation = true
       else
         puts "You have to select a Number"
         puts "How large should our ship be?"
         puts "> "
         new_ship_size = gets.chomp
       end
    end
    ship = Ship.new(new_ship_name, new_ship_size)

    @player_ships << ship
    @computer_ships << ship
  end




  def player_place_ships
    system "clear"
    puts "Your enemy has maneuvered their ships within firing range."
    puts "You now need to position your fleet."
    puts "The #{@player_ships[0].name} is #{@player_ships[0].length} spaces long."
    puts " "
    print @player_board.render_board(true)
    puts " "
    puts "Enter the squares for your #{@player_ships[0].name} (#{@player_ships[0].length} spaces) separated by spaces"
    puts "Example: A1 A2 A3"

    good_ship = false
    until good_ship
      print "> "
      ship_coordinates = gets.chomp.upcase
      until ship_coordinates.split(" ").to_a.count == @player_ships[0].length
          puts "Please enter #{@player_ships[0].length} coordinates."
          print "> "
          ship_coordinates = gets.chomp.upcase
      end

      ship_array = ship_coordinates.split(" ").to_a

      if @player_board.valid_placement?(@player_ships.shift, ship_array.sort)
        good_ship = true
        @player_board.place(@player_ships.shift, ship_array.sort)
      else
        puts "That's an invalid placement comrade, please try again."
      end
    end
  end
  #   good_cruiser = false
  #   until good_cruiser
  #     print "> "
  #     cruiser_spaces = gets.chomp.upcase
  #     until cruiser_spaces != ""
  #       if cruiser_spaces == ""
  #         puts "Please enter 3 coordinates."
  #         print "> "
  #         cruiser_spaces = gets.chomp.upcase
  #       end
  #     end
  #     cruiser_array = cruiser_spaces.split(" ").to_a
  #     if @player_board.valid_placement?(@cruiser, cruiser_array.sort)
  #       good_cruiser = true
  #       @player_board.place(@cruiser, cruiser_array.sort)
  #     else
  #       puts "That's an invalid placement comrade, please try again."
  #     end
  #   end
  #
  #   system "clear"
  #   print @player_board.render_board(true)
  #   puts "Enter the squares for your Submarine (2 spaces)"
  #
  #   good_sub = false
  #   until good_sub
  #     print "> "
  #     sub_spaces = gets.chomp.upcase
  #     until sub_spaces != ""
  #       if sub_spaces == ""
  #         puts "Please enter 2 coordinates."
  #         print "> "
  #         sub_spaces = gets.chomp.upcase
  #       end
  #     end
  #     sub_array = sub_spaces.split(" ").to_a
  #     if @player_board.valid_placement?(@sub, sub_array.sort)
  #       good_sub = true
  #       @player_board.place(@sub, sub_array.sort)
  #     else
  #       puts "That's an invalid placement comrade, please try again."
  #     end
  #   end
  #   system "clear"
  # end
#
#   def computer_place_cruiser
#     @computer_cruiser = Ship.new("Cruiser", 3)
#     @cruiser_coordinates = ["A1", "B2", "C3"]
#     until @computer_board.valid_placement?(@computer_cruiser, @cruiser_coordinates) == true
#       @cruiser_coordinates = @computer_board.cells.keys.sample(3)
#     end
#     @computer_board.place(@computer_cruiser, @cruiser_coordinates)
#   end
#
#   def computer_place_sub
#     @computer_sub = Ship.new("Submarine", 2)
#     @sub_coordinates = ["A1", "A3"]
#     until @computer_board.valid_placement?(@computer_sub, @sub_coordinates) == true
#       @sub_coordinates = @computer_board.cells.keys.sample(2)
#     end
#     @computer_board.place(@computer_sub, @sub_coordinates)
#   end
#
#   def take_turn
#     puts "=============COMPUTER BOARD============="
#     print @computer_board.render_board
#     puts " "
#     puts "==============PLAYER BOARD=============="
#     print @player_board.render_board(true)
#     puts " "
#     puts "============Battle Stations!============"
#
#     puts "Comrade, enemy ships detected. Where should we fire?"
#     print "Enter your firing coordinate: "
#     good_shot = false
#     until good_shot
#       print "> "
#       player_shot = gets.chomp.upcase.to_s
#       if @computer_board.valid_coordinate?(player_shot) && !@computer_board.cells[player_shot].fired_upon?
#          @computer_board.cells[player_shot].fire_upon
#          good_shot = true
#       else
#          puts "I don't think that's wise Comrade."
#          puts "Please enter a valid firing coordinate you haven't already chosen."
#       end
#     end
#
#     shot_result = nil
#
#     if @computer_board.cells[player_shot].render == "M"
#       shot_result = "was a miss"
#     elsif @computer_board.cells[player_shot].render == "H"
#       shot_result = "was a hit"
#     elsif @computer_board.cells[player_shot].render == "X"
#       shot_result = "sunk the enemy's #{@computer_board.cells[player_shot].ship.name}"
#     end
#     system "clear"
#     puts "Comrade, your shot at #{player_shot} #{shot_result}!"
#     computer_take_turn
#   end
#
#   def computer_take_turn
#     good_shot = false
#     computer_shot = "A4"
#     until good_shot
#       computer_shot = @player_board.cells.keys.sample(1)
#       if @player_board.valid_coordinate?(computer_shot[0]) && !@player_board.cells[computer_shot[0]].fired_upon?
#         @player_board.cells[computer_shot[0]].fire_upon
#         good_shot = true
#       end
#     end
#     shot_result = nil
#     if @player_board.cells[computer_shot[0]].render == "M"
#       shot_result = "was a miss"
#     elsif @player_board.cells[computer_shot[0]].render == "H"
#       shot_result = "was a hit"
#     elsif @player_board.cells[computer_shot[0]].render == "X"
#       shot_result = "sunk your #{@player_board.cells[computer_shot[0]].ship.name}"
#     end
#     puts "The enemy's shot at #{computer_shot[0]} #{shot_result}!"
#     puts "========================================"
#     puts " "
#   end
end
