# frozen_string_literal: true

# it's the cell
class Cell
  attr_reader :alive, :neighbours

  def initialize(alive: false)
    @alive = api_alive_to_internal(alive)
  end

  def alive=(alive)
    @alive = api_alive_to_internal(alive)
  end

  def alive?
    internal_alive_to_api(@alive)
  end

  def add_neighbours(neighbours)
    @neighbours = neighbours
  end

  def living_neighbour_count
    @neighbours.map(&:alive).sum
  end

  def tick
    return tick_alive if alive?

    tick_dead
  end

  def tick_alive
    return self.alive = true if [2, 3].include?(living_neighbour_count)

    self.alive = false
  end

  def tick_dead
    return self.alive = true if living_neighbour_count == 3

    self.alive = false
  end

  private

  def api_alive_to_internal(alive)
    alive ? 1 : 0
  end

  def internal_alive_to_api(internal_alive)
    internal_alive == 1
  end
end

# This class will run the game
class Game
  def initialize(board)
    @board = board
  end

  def cell_alive?(x:, y:) # rubocop:disable Naming/MethodParameterName
    @board[x][y].alive?
  end

  def cell_at(x:, y:) # rubocop:disable Naming/MethodParameterName
    @board[x][y]
  end
end
