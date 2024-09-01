# frozen_string_literal: true

class AddGenerationToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :generation, :integer, default: 0
  end
end
