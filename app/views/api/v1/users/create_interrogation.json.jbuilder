int ||= @interrogation

json.id int.id
json.response int.response
json.next_interval int.next_interval
json.next_date int.next_date
json.card_id int.card_id
json.easiness_factor int.easiness_factor

#  id              :integer          not null, primary key
#  response        :integer
#  old_interval    :integer
#  next_interval   :integer
#  next_date       :date
#  easiness_factor :integer
#  user_id         :integer
#  card_id         :integer
#  date_response   :date