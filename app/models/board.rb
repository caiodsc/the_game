# frozen_string_literal: true

class Board < ApplicationRecord
  serialize :grid, type: Array, coder: JSON

  validates_presence_of :height, :width, :grid
  validates_numericality_of :height, :width, greater_than: 0
  validate :grid_width_consistency

  after_initialize :set_dimensions

  def set_dimensions
    self.height = grid.size
    self.width = (grid.first || []).size
  end

  private

  def grid_width_consistency
    return if grid.all? { |row| row.size == width }

    errors.add(:grid, 'must be an array of arrays with consistent width')
  end
end
