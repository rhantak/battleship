require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship.rb'
require './lib/cell.rb'

class CellTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser",3)
    @cell = Cell.new("B4")
  end

  def test_cell_exists
    assert_instance_of Cell, @cell
  end

  def test_coordinate
    assert_equal "B4", @cell.coordinate
  end

  def test_ship
    assert_nil @cell.ship

    @cell.place_ship(@cruiser)
    assert_equal @cruiser , @cell.ship
  end

  def test_empty?
    assert_equal true, @cell.empty?

    @cell.place_ship(@cruiser)
    assert_equal false, @cell.empty?
  end

  def test_place_ship
    @cell.place_ship(@cruiser)

    assert_equal false, @cell.empty?
  end

  def test_fired_upon?
    @cell.place_ship(@cruiser)
    assert_equal false, @cell.fired_upon?

    @cell.fire_upon
    assert_equal true, @cell.fired_upon?
  end

  def test_fire_upon
    @cell.place_ship(@cruiser)
    start_health = @cell.ship.health
    @cell.fire_upon

    assert_equal true, @cell.fired_upon?
    assert_equal  start_health - 1, @cell.ship.health
  end

  def test_render_doesnt_show_ship
    @cell.place_ship(@cruiser)

    assert_equal ".".colorize(:green).bold, @cell.render
  end

  def test_render_shows_ship
    @cell.place_ship(@cruiser)

    assert_equal "S".colorize(:green).bold, @cell.render(true)
  end

  def test_render_shows_miss
    @cell.fire_upon

    assert_equal 'M'.colorize(:cyan).bold, @cell.render
  end

  def test_render_shows_hit
    @cell.place_ship(@cruiser)
    @cell.fire_upon

    assert_equal 'H'.colorize(:yellow).bold, @cell.render
  end

  def test_render_shows_sunk
    @cell.place_ship(@cruiser)
    @cell.fire_upon
    @cell.fire_upon
    @cell.fire_upon

    assert_equal 'X'.colorize(:red).bold, @cell.render
  end

end
