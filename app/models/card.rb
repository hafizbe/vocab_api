# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  word       :string(255)
#  english_m  :string(255)
#  sura_id    :integer
#  aya_id     :integer
#  urdu_m     :string(255)
#  juzz_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Card < ActiveRecord::Base
  belongs_to :sura
  has_many :interrogations
  has_many :users, ->{ select("users.*,interrogations.response, interrogations.next_date, interrogations.id as id_interrogation") },
           :through => :interrogations
end
