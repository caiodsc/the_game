# frozen_string_literal: true

class GenerationService
  attr_reader :board

  delegate :height, :width, :grid, to: :board

  DEAD = 0
  ALIVE = 1
  ORIGIN = [0, 0].freeze

  def initialize(board)
    @board = board
  end

  def next(leaps = 1)
    leaps.times { next_generation }

    board
  end

  private

  def next_generation
    new_grid = Array.new(height) do |x|
      Array.new(width) do |y|
        cell_next_state(x, y)
      end
    end

    board.grid = new_grid
    board.increment(:generation)
  end

  def cell_next_state(x, y)
    alive = alive?(x, y)
    alive_neighbors = count_alive_neighbors(x, y)

    return ALIVE if alive && alive_neighbors.between?(2, 3)
    return ALIVE if !alive && alive_neighbors == 3

    DEAD
  end

  def count_alive_neighbors(x, y)
    offsets = [-1, 0, 1].product([-1, 0, 1])

    offsets.excluding([ORIGIN]).count { |nx, ny| alive?(x + nx, y + ny) }
  end

  def alive?(x, y)
    return false if x.negative? || y.negative?

    grid.dig(x, y) == ALIVE
  end
end
