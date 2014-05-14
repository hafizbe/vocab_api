class CreateSuras < ActiveRecord::Migration
  def change
    create_table :suras do |t|
      t.string :name_arabic
      t.string :name_phonetic
      t.integer :nb_cards
      t.integer :nb_versets

      t.timestamps
    end
  end
end
