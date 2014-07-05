class AddFrMeaningToCards < ActiveRecord::Migration
  def change
    add_column :cards, :fr_m, :string
  end
end
