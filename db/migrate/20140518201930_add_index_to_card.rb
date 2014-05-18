class AddIndexToCard < ActiveRecord::Migration
  def change
    add_index :cards, [:sura_id]
  end
end
