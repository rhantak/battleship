require './lib/ship'
require './lib/cell'
require './lib/board'
require 'minitest/autorun'
require 'minitest/pride'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_can_validate_a_coordinate
    assert_equal true, @board.valid_coordinate?("A1")
    refute @board.valid_coordinate?("E14")
  end

  def test_can_validate_ship_placement_is_valid
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
    @board.place(@cruiser, ["A3", "B3", "C3"])

    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])

    refute @board.valid_placement?(@submarine, ["A2", "A3"])
  end

  def test_will_render_and_hide_ships
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["B1", "B2"])

    assert_equal "        1   2   3   4\n    A   .   .   .   .\n    B   .   .   .   .\n    C   .   .   .   .\n    D   .   .   .   .\n", @board.render_board
  end

  def test_will_render_and_show_ships
    @board.place(@cruiser, ["B1", "B2","B3"])
    @board.place(@submarine, ["A1", "A2"])

    assert_equal "        1   2   3   4\n    A   S   S   .   .\n    B   S   S   S   .\n    C   .   .   .   .\n    D   .   .   .   .\n", @board.render_board(true)
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
