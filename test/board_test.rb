require './lib/ship'
require './lib/cell'
require './lib/board'
require 'colorize'

require 'minitest/autorun'
require 'minitest/pride'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new(4, 4)
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end
  # add test to check if number of cells correlates with expected number
  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_can_validate_a_coordinate
    assert_equal true, @board.valid_coordinate?("A1")

    refute @board.valid_coordinate?("E14")
  end

  def test_can_validate_ship_placement_is_valid
    #can use assert, instead of assert_equal true.
    assert_equal true, @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])
    assert_equal true, @board.valid_placement?(@cruiser, ["A1","B1","C1"])
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "B1"])

    refute @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    refute @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    refute @board.valid_placement?(@cruiser,["A1", "B2"])
    refute @board.valid_placement?(@cruiser,["A1", "B1", "D1"])
    refute @board.valid_placement?(@cruiser,["A3", "C3", "D3"])
    refute @board.valid_placement?(@cruiser,["A4", "B4", "D4"])
    refute @board.valid_placement?(@submarine,["A1", "A3"])
    refute @board.valid_placement?(@submarine,["A1", "B2"])
    refute @board.valid_placement?(@submarine,["A1", "B2", "C3"])
  end

  def test_can_validate_ship_placement_doesnt_overlap
    @board.place(@cruiser, ["A3", "B3", "C3"])

    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])

    refute @board.valid_placement?(@submarine, ["A2", "A3"])
  end

  def test_will_render_and_hide_ships
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["B1", "B2"])

    expected = "       1   2   3   4 \n\n" +
               " A     .   .   .   . \n\n" +
               " B     .   .   .   . \n\n" +
               " C     .   .   .   . \n\n" +
               " D     .   .   .   ."
               
    assert_equal expected, @board.render_board
  end

  def test_will_render_and_show_ships
    @board.place(@cruiser, ["B1", "B2","B3"])
    @board.place(@submarine, ["A1", "A2"])

    assert_equal "        1   2   3   4\n    A   #{"S".colorize(:green).bold}   #{"S".colorize(:green).bold}   .   .\n    B   #{"S".colorize(:green).bold}   #{"S".colorize(:green).bold}   #{"S".colorize(:green).bold}   .\n    C   .   .   .   .\n    D   .   .   .   .\n", @board.render_board(true)
  end

  def test_will_render_and_show_hits_misses_sunk
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["B1", "B2"])
    @board.cells["B1"].fire_upon
    @board.cells["B2"].fire_upon
    @board.cells["A3"].fire_upon
    @board.cells["A4"].fire_upon

    assert_equal "        1   2   3   4\n    A   .   .   H   M\n    B   X   X   .   .\n    C   .   .   .   .\n    D   .   .   .   .\n", @board.render_board
  end
end
