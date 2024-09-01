# frozen_string_literal: true

class AddSteadyToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :steady, :boolean, null: false, default: false
  end
end
