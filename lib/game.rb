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
      p "Welcome to BATTLESHIP Comrade!"
      p "Enter 'p' to play. Enter 'q' to quit."
      valid_input = false
      until valid_input
        initial_input = gets.chomp
        if initial_input.downcase == "p"
          valid_input = true
          initialize()
          play_game()
        elsif initial_input.downcase == "q"
          valid_input = true
          quit = "q"
          return "Thanks for playing!"
        else p "That was not a valid input. Enter 'p' to play. Enter 'q' to quit."
        end
      end
    end
  end

  def play_game
    computer_place_cruiser
    computer_place_sub
    player_place_ships
    computer_loss = false
    player_loss = false
    until computer_loss || player_loss
      take_turn
      if @cruiser.sunk? && @computer_cruiser.sunk? && @sub.sunk? && @computer_sub.sunk?
        puts "You and your enemy sunk each other's last ship at the same time!"
        puts "Mutually assured destruction!"
      elsif @cruiser.sunk? && @sub.sunk?
        player_loss = true
        puts "The enemy sunk all your ships! A loss for the Motherland!"
        puts " "
        puts "=" * 40
        puts " "
      elsif @computer_cruiser.sunk? && @computer_sub.sunk?
        computer_loss = true
        puts "You sunk all your enemy's ships! A victory for the Motherland!"
        puts " "
        puts "=" * 40
        puts " "
      end
    end
  end

  def player_place_ships
    @cruiser = Ship.new("Cruiser", 3)
    @sub = Ship.new("Submarine", 2)

    system "clear"
    puts "Your enemy has laid out their ships on the grid."
    puts "You now need to place your two ships."
    puts "The Cruiser is 3 units long and the Submarine is 2 units long."
    puts " "
    print @player_board.render_board(true)
    puts " "
    puts "Enter the squares for your Cruiser (3 spaces) separated by spaces"
    puts "Example: A1 A2 A3"

    good_cruiser = false
    until good_cruiser
      print "> "
      cruiser_spaces = gets.chomp.upcase
      until cruiser_spaces != ""
        if cruiser_spaces == ""
          puts "Please enter 3 coordinates."
          print "> "
          cruiser_spaces = gets.chomp.upcase
        end
      end
      cruiser_array = cruiser_spaces.split(" ").to_a
      if @player_board.valid_placement?(@cruiser, cruiser_array.sort)
        good_cruiser = true
        @player_board.place(@cruiser, cruiser_array.sort)
      else
        puts "That's an invalid placement comrade, please try again."
      end
    end

    system "clear"
    print @player_board.render_board(true)
    puts "Enter the squares for your Submarine (2 spaces)"

    good_sub = false
    until good_sub
      print "> "
      sub_spaces = gets.chomp.upcase
      until sub_spaces != ""
        if sub_spaces == ""
          puts "Please enter 2 coordinates."
          print "> "
          sub_spaces = gets.chomp.upcase
        end
      end
      sub_array = sub_spaces.split(" ").to_a
      if @player_board.valid_placement?(@sub, sub_array.sort)
        good_sub = true
        @player_board.place(@sub, sub_array.sort)
      else
        puts "That's an invalid placement comrade, please try again."
      end
    end
    system "clear"
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

  def take_turn
    puts "=============COMPUTER BOARD============="
    print @computer_board.render_board
    puts " "
    puts "==============PLAYER BOARD=============="
    print @player_board.render_board(true)
    puts " "
    puts "============Battle Stations!============"

    puts "Comrade, enemy ships detected. Where should we fire?"
    print "Enter your firing coordinate: "
    good_shot = false
    until good_shot
      print "> "
      player_shot = gets.chomp.upcase.to_s
      if @computer_board.valid_coordinate?(player_shot) && !@computer_board.cells[player_shot].fired_upon?
         @computer_board.cells[player_shot].fire_upon
         good_shot = true
      else
         puts "I don't think that's wise Comrade."
         puts "Please enter a valid firing coordinate you haven't already chosen."
      end
    end

    shot_result = nil

    if @computer_board.cells[player_shot].render == "M"
      shot_result = "was a miss"
    elsif @computer_board.cells[player_shot].render == "H"
      shot_result = "was a hit"
    elsif @computer_board.cells[player_shot].render == "X"
      shot_result = "sunk the enemy's #{@computer_board.cells[player_shot].ship.name}"
    end
    system "clear"
    puts "Comrade, your shot at #{player_shot} #{shot_result}!"
    computer_take_turn
  end

  def computer_take_turn
    good_shot = false
    computer_shot = "A4"
    until good_shot
      computer_shot = @player_board.cells.keys.sample(1)
      if @player_board.valid_coordinate?(computer_shot[0]) && !@player_board.cells[computer_shot[0]].fired_upon?
        @player_board.cells[computer_shot[0]].fire_upon
        good_shot = true
      end
    end
    shot_result = nil
    if @player_board.cells[computer_shot[0]].render == "M"
      shot_result = "was a miss"
    elsif @player_board.cells[computer_shot[0]].render == "H"
      shot_result = "was a hit"
    elsif @player_board.cells[computer_shot[0]].render == "X"
      shot_result = "sunk your #{@player_board.cells[computer_shot[0]].ship.name}"
    end
    puts "The enemy's shot at #{computer_shot[0]} #{shot_result}!"
    puts "========================================"
    puts " "
  end
end
