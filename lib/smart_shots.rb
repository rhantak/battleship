require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game.rb'
require 'pry'

class SmartShots
    def initialize(board)
    @board = board
    @width = board.board_width
    @length = board.board_length
    @small_dim = [@width, @length].min
    @cells = board.cells
    @oriented = "?"
  end

  def generate_smart_shots
    @hits = []
    @next_targs = []
    @best_targs = []
    @consec_hits = []
    identify_hits
    vertical_check
    horizontal_check
    if @hits != []
      check_for_consecutive_hits
      if @consec_hits != []
        return check_best_targs()
      else
        return @next_targs
      end
    end
  end

  def identify_hits
    @cells.map do |coord, cell|
      if @cells[coord].render == "H"
      @hits << coord
      end
    end
  end

  def horizontal_check
    @hits.map do |hit|
      letter = hit[0]
      number = hit.gsub(/[A-Z]/,"")
      left_coord = letter + "#{number.to_i+1}"
      right_coord = letter + "#{number.to_i-1}"
      left_sub = left_coord.gsub(/[A-Z]/,"")
      right_sub = right_coord.gsub(/[A-Z]/,"")
      if  (1..@small_dim).include?(left_sub.to_i) && (1..@small_dim).include?(right_sub.to_i)
        @next_targs << left_coord
        @next_targs << right_coord
      elsif (1..@small_dim).include?(left_sub.to_i)
        @next_targs << left_coord
      elsif (1..@small_dim).include?(right_sub.to_i)
        @next_targs << right_coord
      end
    end
  end

  def vertical_check
    @hits.map do |hit|
      letter = hit[0].ord
      number = hit.gsub(/[A-Z]/,"")
      above_coord = (letter - 1).chr + number
      below_coord = (letter + 1).chr + number
      if ("A".."Z").include?(above_coord[0]) && ("A".."Z").include?(below_coord[0])
        @next_targs << above_coord
        @next_targs << below_coord
      elsif ("A".."Z").include?(above_coord[0])
        @next_targs << above_coord
      elsif ("A".."Z").include?(below_coord[0])
        @next_targs << below_coord
      end
    end
  end

  def check_for_consecutive_hits
    @hits.each do |coord|
      if @next_targs.include?(coord) && @board.cells[coord].render == "H"
        @consec_hits << coord
      end
    end
    @letters1 = []
    @consec_hits.each do |coord|
      @letters1 << coord[0]
    end
    if @letters1.uniq.size == 1
      @oriented = "h"
    else
      @oriented = "v"
    end
  end

  def check_best_targs
    if @oriented == "h"
      letter = @consec_hits[0][0]
      num1 = @consec_hits[0].gsub(/[A-Z]/,"")
      num2 = @consec_hits[1].gsub(/[A-Z]/,"")
      @best_targs << letter + "#{num1.to_i + 1}"
      @best_targs << letter + "#{num2.to_i - 1}"
    elsif @oriented == "v"
      number = @consec_hits[0].gsub(/[A-Z]/,"")
      letter1 = @consec_hits[0][0].ord
      letter2 = @consec_hits[1][0].ord
      @best_targs << (letter1 - 1).chr + number
      @best_targs << (letter1 + 1).chr + number
    end
    @best_targs
  end
end
