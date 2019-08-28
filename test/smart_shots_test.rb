require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require './lib/smart_shots'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < Minitest::Test
  def setup
    @board = Board.new(4,4)
    @smart = SmartShots.new(@board)
    @boat = Ship.new("Boaty McBoatface", 3)
    @board.place(@boat, ["A1","A2","A3"])
  end

  def test_board_exists
    @board = Board.new(4,4)
  end

  def test_it_exists
    assert_instance_of SmartShots, @smart
  end

  def test_it_doesnt_do_anything_with_no_hits
    array = @smart.generate_smart_shots
    assert_nil array
  end

  def test_it_can_identify_hits
    @board.cells["A2"].fire_upon

    assert_equal ["A2"], @smart.identify_hits
  end

  def test_it_can_generate_smart_shots_from_one_hit
    @board.cells["A2"].fire_upon

    assert_equal ["A1","A3","B2"], @smart.generate_smart_shots.sort
  end

  def test_it_can_generate_smarter_shots_from_two_consecutive_hits
    @board.cells["A2"].fire_upon
    @board.cells["A3"].fire_upon

    assert_equal ["A1","A4"], @smart.generate_smart_shots
  end
end
