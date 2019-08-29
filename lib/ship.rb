class Ship
attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end

  def sunk?
    # change to health <= 0
    @health == 0
  end

  def hit
    @health -= 1
  end
end
