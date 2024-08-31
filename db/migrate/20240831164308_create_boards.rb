# frozen_string_literal: true

class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.integer :height, null: false
      t.integer :width, null: false
      t.text :grid, null: false

      t.timestamps
    end
  end
end
