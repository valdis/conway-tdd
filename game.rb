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

  def inspect
    to_s
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
    @board = board_with_introduced_neighbours(board)
  end

  def cell_alive?(x:, y:) # rubocop:disable Naming/MethodParameterName
    @board[x][y].alive?
  end

  def cell_at(x:, y:) # rubocop:disable Naming/MethodParameterName
    cell_at_for_board(board: @board, x: x, y: y)
  end

  private

  def cell_at_for_board(board:, x:, y:) # rubocop:disable Naming/MethodParameterName
    return nil if x.negative? || x > (board.size - 1)
    return nil if y.negative? || y > (board[x].size - 1)

    board[x][y]
  end

  def board_with_introduced_neighbours(board)
    board.each.with_index do |col, x|
      col.each.with_index do |cell, y|
        cell.add_neighbours(neighbours_for_cell_at(board: board, x: x, y: y))
      end
    end
  end

  def neighbours_for_cell_at(board:, x:, y:) # rubocop:disable Naming/MethodParameterName
    neighbour_coords_at(x: x, y: y)
      .map { |coord| cell_at_for_board(board: board, x: coord[:x], y: coord[:y]) }
      .compact
  end

  def neighbour_coords_at(x:, y:) # rubocop:disable Naming/MethodParameterName
    [
      { x: x - 1, y: y - 1 }, { x: x, y: y - 1 }, { x: x + 1, y: y - 1 },
      { x: x - 1, y: y     },                     { x: x + 1, y: y },
      { x: x - 1, y: y + 1 }, { x: x, y: y + 1 }, { x: x + 1, y: y + 1 }
    ]
  end
end
