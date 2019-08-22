require './lib/ship.rb'
require 'pry'
class Cell
  attr_reader :ship, :coordinate

  def initialize(coordinate)
    @ship = nil
    @coordinate = coordinate
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    if !empty?
      @ship.hit
    end
    @fired_upon = true
  end

  def render(show = false)
    if @fired_upon == false
      if show == true && !empty?
         'S'
      else
         '.'
      end
    elsif @fired_upon == true
      if empty?
         'M'
      else
        if @ship.health > 0
           'H'
        elsif @ship.health <= 0
           'X'
        end
      end
    end
  end
end
