require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/smart_shots'
require 'colorize'

class Game
  attr_reader :player_board, :computer_board, :player_ships_in_play, :computer_ships_in_play


  def initialize
    system "clear"
    @player_ships = []
    @computer_ships = []
    @player_ships_in_play = 0
    @computer_ships_in_play = 0
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
          puts "Thanks for playing!"
        else p "That was not a valid input. Enter 'p' to play. Enter 'q' to quit."
        end
      end
    end
  end

  def play_game
    ask_for_dimensions
    @player_board = Board.new(@width, @length)
    @computer_board = Board.new(@width, @length)
    @smart_shots = SmartShots.new(@player_board)
    player_create_ships
    computer_place_ships
    player_place_ships
    system "clear"
    is_game_over?
  end

  def is_game_over?
    computer_loss = false
    player_loss = false
    player_ships_sunk = false
    computer_ships_sunk = false
    until computer_loss || player_loss
      take_turn

      if @player_ships_in_play <= 0
        player_ships_sunk = true
      elsif @computer_ships_in_play <= 0
        computer_ships_sunk = true
      end

      if player_ships_sunk
        player_loss = true
        system "clear"
        puts "The enemy sunk all your ships! A loss for the Motherland!"
        puts " "
        puts "=============COMPUTER BOARD============="
        puts @computer_board.render_board(true)
        puts " "
        puts "==============PLAYER BOARD=============="
        puts @player_board.render_board(true)
        puts " "
      elsif computer_ships_sunk
        computer_loss = true
        system "clear"
        puts "You sunk all your enemy's ships! A victory for the Motherland!"
        puts " "
        puts "=============COMPUTER BOARD============="
        puts @computer_board.render_board(true)
        puts " "
        puts "==============PLAYER BOARD=============="
        puts @player_board.render_board(true)
        puts " "
        puts " "
        fleet_status
      end
    end
  end

  def ask_for_dimensions
    puts "Choose a number between 1 and 12 for your board's width."
    @width = gets.chomp.to_i
    until @width <= 12 && @width >= 1
      puts "That's not going to work, please choose a number between 1 and 12."
      @width = gets.chomp.to_i
    end
    puts "Ok, now choose a number between 1 and 12 for your board's length."
    @length = gets.chomp.to_i
    until @length <= 12 && @length >=1
      puts "That's not going to work, please choose a number between 1 and 12."
      @length = gets.chomp.to_i
    end
  end

  def player_create_ships
    system "clear"
    puts "The enemy is approaching. We must mobilize your fleet!"
    puts "What ship should we add to your fleet comrade?"
    puts " "
    puts "Aircraft Carriers: Enterprise, Midway, Ranger, Nimitz (Size: 5)"
    puts "Battleships: Texas, Kearsarge, Iowa, Arizona, Missouri, Yamato, Bismark (Size: 4)"
    puts "Cruisers & Destroyers: Ticonderoga, Fitzgerald, John McCain, Cole, Kidd (Size: 3)"
    puts "Submarines: Tang, Thresher, Silversides, Flasher, Seahorse, Ohio (Size: 2)"
    puts " "
    if @player_ships != []
    list_ships
    end
    puts ""
    puts "Enter the name of our ship."
    print "> "
    new_ship_name = gets.chomp.to_s.capitalize

    new_ship = false
    until new_ship
      if
        new_ship_name.length >= 3
        new_ship = true
      else
        # Tell them why it wasn't accepted
        puts "Try naming it something else"
        print "> "
        new_ship_name = gets.chomp.to_s.capitalize
      end
    end

      puts "How large should your ship be?"
      print "> "
      new_ship_size = gets.chomp.to_i
      new_ship_size_validation = false
    until new_ship_size_validation
      is_int = (1..12).include?(new_ship_size)
      if is_int && (new_ship_size <= @width || new_ship_size <= @length)
        new_ship_size_validation = true
      else
        puts "You have to select a number that fits on the board."
        puts "How large should your ship be?"
        print "> "
        new_ship_size = gets.chomp.to_i
      end
    end
    player_ship = Ship.new(new_ship_name, new_ship_size)
    computer_ship = Ship.new(new_ship_name, new_ship_size)
    @player_ships_in_play += 1
    @computer_ships_in_play += 1
    @player_ships << player_ship
    @computer_ships << computer_ship
    player_create_more_ships
  end

  def list_ships
    puts "Your current ships are:"
    puts " "
  @player_ships.each do |ship|
    puts "USS #{ship.name}, #{ship.length} squares long."
    end
  end

  def fleet_status
    fleet = []
    @player_board.cells.each do |coord, cell|
      if cell.ship != nil
        fleet << cell.ship
      end
        fleet = fleet.uniq
      end

    puts " "
    puts "Your fleet:"
      fleet.each do |ship|
        if ship.length == ship.health
          puts "USS #{ship.name}, #{ship.health} health remaining. Systems nominal.".colorize(:green)
        elsif ship.length >= ship.health && ship.health > 0
          puts "USS #{ship.name}, #{ship.health} health remaining. We're taking on water!".colorize(:yellow)
        elsif ship.health <= 0
          puts "USS #{ship.name}, mayday... mayday... we're going down. Deploy Liferafts!".colorize(:red)
        end
      end
  end

  def player_create_more_ships
    system "clear"
    puts "Would you like to add another ship to the fleet?"
    list_ships
    puts " "
    puts "Enter y for Yes."
    puts "Enter n for No."
    player_choice = gets.chomp.downcase
    if
      player_choice == "n"
      player_place_ships
    elsif
      player_choice == "y"
      player_create_ships
    else
      puts "Please enter either 'y' (Yes) or 'n' (No)."
      player_create_more_ships
    end
  end


  def player_place_ships
    until @player_ships == []
        system "clear"
        puts "Your enemy has maneuvered their ships within firing range."
        puts "You now need to position your fleet."
        list_ships
        puts " "
        puts "You must place the USS #{@player_ships[0].name}, it is #{@player_ships[0].length} spaces long."
        puts " "
        print @player_board.render_board(true)
        puts " "
        puts " "
        puts "Enter the squares for the USS #{@player_ships[0].name} (#{@player_ships[0].length} spaces) separated by spaces"
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

        if @player_board.valid_placement?(@player_ships[0], ship_array.sort)
          good_ship = true
          @player_board.place(@player_ships.shift, ship_array.sort)
        else
          puts "That's an invalid placement comrade, please try again."
        end
      end
    end
  end


  def computer_place_ships
    until @computer_ships == []
      ship_coordinates = ["A1", "B2", "C3"]
      until @computer_board.valid_placement?(@computer_ships[0], ship_coordinates) == true
        ship_coordinates = @computer_board.cells.keys.sample(@computer_ships[0].length)
      end
      @computer_board.place(@computer_ships.shift, ship_coordinates)
    end
  end


  def take_turn
    puts "=============COMPUTER BOARD=============\n"
    puts " "
    print @computer_board.render_board
    puts " "
    puts " "
    puts "==============PLAYER BOARD==============\n"
    puts " "
    print @player_board.render_board(true)
    puts " "
    puts " "
    puts "============Battle Stations!============\n"
    puts " "
    fleet_status
    puts " "
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
    if @computer_board.cells[player_shot].render == "M".colorize(:cyan).bold
      shot_result = "was a miss"
    elsif @computer_board.cells[player_shot].render == "H".colorize(:yellow).bold
      shot_result = "was a hit"
    elsif @computer_board.cells[player_shot].render == "X".colorize(:red).bold
      shot_result = "sunk the enemy's #{@computer_board.cells[player_shot].ship.name}"
      @computer_ships_in_play -= 1
    end
    system "clear"
    puts "Comrade, your shot at #{player_shot} #{shot_result}!"
    puts "========================================"
    computer_take_turn
  end


  def computer_take_turn
    good_shot = false
    computer_shot = "Z13"
    until good_shot
      if @smart_shots.generate_smart_shots != nil
        computer_shot = @smart_shots.generate_smart_shots.sample(1)
      else
        computer_shot = @player_board.cells.keys.sample(1)
      end
      if @player_board.valid_coordinate?(computer_shot[0]) && !@player_board.cells[computer_shot[0]].fired_upon?
        @player_board.cells[computer_shot[0]].fire_upon
        good_shot = true
      end
    end
    shot_result = nil
    if @player_board.cells[computer_shot[0]].render == "M".colorize(:cyan).bold
      shot_result = "was a miss"
    elsif @player_board.cells[computer_shot[0]].render == "H".colorize(:yellow).bold
      shot_result = "was a hit"
    elsif @player_board.cells[computer_shot[0]].render == "X".colorize(:red).bold
      shot_result = "sunk your #{@player_board.cells[computer_shot[0]].ship.name}"
      @player_ships_in_play -= 1
    end
    puts "The enemy's shot at #{computer_shot[0]} #{shot_result}!"
    puts " "
    puts " "
  end
end
