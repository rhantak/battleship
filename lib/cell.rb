require './lib/ship.rb'
require 'colorize'

class Cell
  attr_reader :ship, :coordinate

  def initialize(coordinate)
    @ship = nil
    @coordinate = coordinate
    @fired_upon = false
  end

  def empty?
    #better to put
    #@ship.nil?
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
         'S'.colorize(:green).bold
      else
         '.'.colorize(:green).bold
      end
      #could be an else because there are only two possible conditions.
    elsif @fired_upon == true
      if empty?
         'M'.colorize(:cyan).bold
      else
        if @ship.health > 0
           'H'.colorize(:yellow).bold
           #ship.sunk is better than health <= 0
        elsif @ship.health <= 0
           'X'.colorize(:red).bold
        end
      end
    end
  end
end
