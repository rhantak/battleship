require './lib/ship.rb'
require 'pry'
class Cell
  attr_reader :ship, :coordinate, :fired_upon

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
    if @ship != nil
      @ship.hit
    end
    @fired_upon = true
  end

  def render(show = false)
    if fired_upon == false
      if show == true && @ship != nil
        p "S"
      else
        p "."
      end
    elsif fired_upon == true
      if @ship == nil
        p "M"
      else
        if @ship.health > 0
          p "H"
        elsif @ship.health <= 0
          p "X"
        end
      end
    end
  end
end
