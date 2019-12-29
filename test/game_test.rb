require './lib/game'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < Minitest::Test

  def setup
    @board = Board.new(4,4)
    @game = Game.new
  end

  def test_it_exists

    assert_instance_of Game, @game
  end
end
