class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :word
      t.string :english_m
      t.integer :sura_id
      t.integer :aya_id
      t.string :urdu_m
      t.integer :juzz_id

      t.timestamps
    end
  end
end
