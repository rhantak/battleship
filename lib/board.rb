require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class Board
  attr_reader :cells, :board_width, :board_length

  def initialize(width, length)
    @cells = {}
    @board_width = width
    @board_length = length
    length_letter = (64+length.to_i).chr

    letters = Range.new("A", length_letter).to_a
    numbers = Range.new(1, width).to_a
    letters.each do |letter|
      numbers.each do |number|
        @cells["#{letter}#{(number.to_s)}"] = Cell.new("#{letter}#{(number.to_s)}")
      end
    end
  end

  def valid_coordinate?(cell)
    @cells.keys.include?(cell)
  end

  def valid_placement?(ship, array)
    ship_is_placed_in_a_straight_line?(ship, array) && ship_isnt_placed_on_another_ship?(array)
  end

  def ship_is_placed_in_a_straight_line?(ship, array)
    letters = array.map {|coordinate| coordinate[0]}
    numbers = array.map {|coordinate| coordinate[1]}
    yrange = Range.new(letters.sort.first, letters.sort.last).count
    xrange = Range.new(numbers.sort.first, numbers.sort.last).count

    # Passed in array is horizontally consecutive and all letters are the same (placed on same row)
    if letters.uniq.count == 1 && xrange == ship.length
      true
    # Passed in array is vertically consecutive and all numbers are the same (placed in same column)
    elsif numbers.uniq.count == 1 && yrange == ship.length
      true
    else
      false
    end
  end

  def ship_isnt_placed_on_another_ship?(array)
    # Make sure cell.ship is nil for all cells in placement array
    array.all? do |coordinate|
      @cells[coordinate].ship == nil
    end
  end

  def place(ship, array)
    array.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def render_board(show = false)
    letters = @cells.keys.map {|coordinate| coordinate[0]}.uniq
    numbers = @cells.keys.map {|coordinate| coordinate.gsub(/[A-Z]/,'')}.uniq
    render_string = "\s \s \s  "
    numbers.each do |number|
      if number.to_s.length == 1
        render_string += "#{number} \s "
      elsif number.to_s.length == 2
        render_string += "#{number} \s"
      end
    end
    letters.each do |letter|
      render_string += "\n\n #{letter} \s"
      numbers.each do |number|
        render_string += " \s " + @cells["#{letter}#{number}"].render(show)
      end
    end
    render_string
  end

end
