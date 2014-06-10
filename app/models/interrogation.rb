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

  def revision(response)
    spaced_repetition = SpacedRepetition::Sm2.new response, self.next_interval, self.easiness_factor

    next_date = spaced_repetition.next_repetition_date
    response = response
    date_response = Time.now
    easiness_factor = spaced_repetition.easiness_factor
    next_interval = spaced_repetition.interval
    self.update_attributes(:next_date => next_date, :response => response, :date_response => date_response,
                           :easiness_factor => easiness_factor, :next_interval  => next_interval)

    self
  end

end
