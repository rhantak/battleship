require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < Minitest::Test

  def setup
    @board = Board.new(4,4)
    @game = Game.new(@board)
  end

  def test_it_exists

    assert_instance_of Game, @game
  end

  def test_it_accepts_board

    assert_equal @board, @game.board
  end

end
