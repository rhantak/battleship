require './lib/ship'
require './lib/cell'
require './lib/board'
require 'minitest/autorun'
require 'minitest/pride'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_can_validate_a_coordinate
    assert_equal true, @board.valid_coordinate?("A1")
    refute @board.valid_coordinate?("E14")
  end

  def test_can_validate_ship_placement_is_valid
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)

    assert_equal true, @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])
    assert_equal true, @board.valid_placement?(@cruiser, ["A1","B1","C1"])
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "B1"])

    refute @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    refute @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    refute @board.valid_placement?(@cruiser,["A1", "B2"])
    refute @board.valid_placement?(@submarine,["A1", "A3"])
    refute @board.valid_placement?(@submarine,["A1", "B2"])
    refute @board.valid_placement?(@submarine,["A1", "B2", "C3"])
  end

  def test_can_validate_ship_placement_doesnt_overlap
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @board.cells["A3"].place_ship(@cruiser)
    @board.cells["B3"].place_ship(@cruiser) 
    @board.cells["C3"].place_ship(@cruiser)

    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])

    refute @board.valid_placement?(@submarine, ["A2", "A3"])
  end
end
