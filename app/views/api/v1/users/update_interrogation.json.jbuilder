int ||= @interrogation

json.id int.id
json.response int.response
json.next_interval int.next_interval
json.next_date int.next_date
json.card_id int.card_id
json.easiness_factor int.easiness_factor
json.sura_id int.card.sura_id
json.date_response ServiceConvertor.date_to_fr(int.date_response)
json.percentage_sura @current_user.nb_points_by_sura int.card.sura_id
json.statistics_sura @current_user.sura_statistics(int.card.sura_id)