class CreateInterrogations < ActiveRecord::Migration
  def change
    create_table :interrogations do |t|
      t.integer :response
      t.integer :old_interval
      t.integer :next_interval
      t.date :next_date
      t.decimal :easiness_factor
      t.integer :user_id
      t.integer :card_id
      t.date :date_response
      t.timestamps
    end
      add_index :interrogations, :card_id
      add_index :interrogations, :user_id
      add_index :interrogations, [:card_id, :user_id, :date_response], :unique => true, :name =>"Index unique Interrogations"
  end
end
