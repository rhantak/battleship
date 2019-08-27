require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game.rb'
require 'pry'

class SmartShots
    def initialize(board)
    @width = board.board_width
    @length = board.board_length
    @small_dim = [@width, @length].min
    @hits = []
    @next_targs = []
    @cells = board.cells
  end

  def generate_smart_shots
    identify_hits
    vertical_check(@hits)
    horizontal_check(@hits)
    @next_targs
  end

  def identify_hits
    @cells.map do |coord, cell|
      if @cells[coord].render == "H"
      @hits << coord
      end
    end
  end

  def horizontal_check(hits)
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

  def vertical_check(hits)
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
end
