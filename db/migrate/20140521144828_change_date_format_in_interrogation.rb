class ChangeDateFormatInInterrogation < ActiveRecord::Migration
  def change
    change_column :interrogations, :date_response, :datetime
  end
end
