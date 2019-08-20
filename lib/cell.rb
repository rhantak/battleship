require './lib/ship.rb'

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
    @ship.hit
    @fired_upon = true
  end

  def render
    #
  end
end
