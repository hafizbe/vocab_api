# == Schema Information
#
# Table name: interrogations
#
#  id              :integer          not null, primary key
#  response        :integer
#  old_interval    :integer
#  next_interval   :integer
#  next_date       :date
#  easiness_factor :integer
#  user_id         :integer
#  card_id         :integer
#  date_response   :date
#  created_at      :datetime
#  updated_at      :datetime
#

class Interrogation < ActiveRecord::Base
	belongs_to :card
  belongs_to :user
end
