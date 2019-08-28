require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game.rb'

class SmartShots
  def initialize(board)
    @board = board
    @width = board.board_width
    @length = board.board_length
    @cells = board.cells
    @hits = []
  end

  def generate_smart_shots
    @hits = []
    @next_targs = []
    @best_targs = []
    @consec_hits = []
    @oriented = "?"
    identify_hits
    if @hits != []
      vertical_check()
      horizontal_check()
      # check_for_consecutive_hits()
      if @consec_hits != []
        check_best_targs()
        return @best_targs.compact
      else
      return @next_targs.compact
      end
    end
  end

  def identify_hits
    # Checks all cell.render for "H" which is a hit, but not sunk, ship
    @cells.map do |coord, cell|
      if @cells[coord].render == 'H'.colorize(:yellow).bold
      @hits << coord
      end
    end
    @hits = @hits.compact
  end

  def horizontal_check
    @hits.map do |hit|
      # Separate the letter from the hit
      letter = hit[0]
      # Separate the number from the hit
      number = hit.gsub(/[A-Z]/,"").to_i
      # To the left of it is same letter, number - 1
      left_num = number - 1
      # To the right of it is same letter, number + 1
      right_num = number + 1
      left_coord = letter + "#{left_num}"
      right_coord = letter + "#{right_num}"
      if (1..@width).include?(left_num) && (1..@width).include?(right_num)
        @next_targs << left_coord
        @next_targs << right_coord
      elsif (1..@width).include?(left_num)
        @next_targs << left_coord
      elsif (1..@width).include?(right_num)
        @next_targs << right_coord
      end
    end
  end

  def vertical_check
    @hits.map do |hit|
      max_letter = (@length + 64).chr
      # Separate the letter from the hit and make it an orinal value so we can move one above and one below
      letter = hit[0].ord
      # Separate the number from the hit
      number = hit.gsub(/[A-Z]/,"")
      # Coordinate above is going to be ordinal value of the letter - 1, back into a character
      above_coord = (letter - 1).chr + number
      # Coordinate below is going to be ordinal value of the letter + 1, back into a character
      below_coord = (letter + 1).chr + number
      if ("A"..max_letter).include?(above_coord[0]) && ("A"..max_letter).include?(below_coord[0])
        @next_targs << above_coord
        @next_targs << below_coord
      elsif ("A"..max_letter).include?(above_coord[0])
        @next_targs << above_coord
      elsif ("A"..max_letter).include?(below_coord[0])
        @next_targs << below_coord
      end
    end
  end

  # def check_for_consecutive_hits
  #   # Consecutive hits in a row or column are much better odds, so let's identify them
  #   @hits.each do |coord|
  #     # If a coordinate is both a hit and a next target, it is consecutive with another hit
  #     if @next_targs.include?(coord) && @board.cells[coord].render == "H"
  #       @consec_hits << coord
  #     end
  #   end
  #   @letters1 = []
  #   @consec_hits.each do |coord|
  #     @letters1 << coord[0]
  #   end
  #   # If letters are the same, it's in a row
  #   if @letters1.uniq.size == 1
  #     @oriented = "h"
  #   # Otherwise it's in a column
  #   else
  #     @oriented = "v"
  #   end
  # end

  def check_best_targs
    if @oriented == "h"
      @consec_hits = @consec_hits.sort
      letter = @consec_hits[0][0]
      num1 = @consec_hits[0].gsub(/[A-Z]/,"").to_i
      num2 = @consec_hits[1].gsub(/[A-Z]/,"").to_i
      # Add a shot to the left 2 hits
      @best_targs << letter + "#{num1 - 1}"
      # Add a shot to the right of the 2 hits
      @best_targs << letter + "#{num2 + 1}"
    elsif @oriented == "v"
      number = @consec_hits[0].gsub(/[A-Z]/,"")
      letter1 = @consec_hits[0][0].ord
      letter2 = @consec_hits[1][0].ord
      # Add a shot above the two hits
      @best_targs << (letter1 - 1).chr + number
      # Add a shot below the two hits
      @best_targs << (letter1 + 1).chr + number
    end
    @best_targs
  end
end
