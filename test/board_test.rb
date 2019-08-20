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
    assert_equal true, valid_coordinate?("A1")
    assert_equal false, valid_coordinate?("E14")
  end
end
