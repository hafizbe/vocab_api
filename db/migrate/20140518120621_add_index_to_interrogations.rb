class AddIndexToInterrogations < ActiveRecord::Migration
  def change
    add_index :interrogations, [:card_id, :user_id], :unique => true
  end
end
