require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'

class ShipTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @sub = Ship.new("Sub", 2)
  end

  def test_ship_exists
    assert_instance_of Ship, @cruiser
  end

  def test_cruiser_has_name
    assert_equal "Cruiser", @cruiser.name
    assert_equal "Sub", @sub.name
  end

  def test_cruiser_has_length
    assert_equal 3, @cruiser.length
    assert_equal 2, @sub.length
  end

  def test_cruiser_has_health
    assert_equal 3, @cruiser.health
  end

  def test_unhit_cruiser_sunk_boolean
    assert_equal false, @cruiser.sunk?
  end

  def test_cruiser_health_registers_first_hit
    @cruiser.hit

    assert_equal 2, @cruiser.health
  end

  def test_cruiser_health_registers_second_hit
    @cruiser.hit
    @cruiser.hit

    assert_equal 1, @cruiser.health
    assert_equal false, @cruiser.sunk?
  end

  def test_cruiser_registers_sunk
    @cruiser.hit
    @cruiser.hit
    @cruiser.hit

    assert_equal true, @cruiser.sunk?
  end
end
