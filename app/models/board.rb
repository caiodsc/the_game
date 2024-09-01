# frozen_string_literal: true

class Board < ApplicationRecord
  serialize :grid, type: Array, coder: JSON

  validates :height, :width, :grid, presence: true
  validates :height, :width, numericality: { greater_than: 0 }
  validate :grid_width_consistency

  after_initialize :set_dimensions

  def token
    Digest::MD5.hexdigest(grid.join)
  end

  private

  def set_dimensions
    self.height = grid.size
    self.width = Array(grid.first).size
  end

  def grid_width_consistency
    return if grid.all? { |row| row.size == width }

    errors.add(:grid, 'must be an array of arrays with consistent width')
  end
end
