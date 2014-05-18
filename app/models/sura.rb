# == Schema Information
#
# Table name: suras
#
#  id            :integer          not null, primary key
#  name_arabic   :string(255)
#  name_phonetic :string(255)
#  nb_cards      :integer
#  nb_versets    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Sura < ActiveRecord::Base
	has_many :cards
end
