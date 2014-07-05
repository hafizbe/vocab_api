cards ||= @cards
json.percentage_total @current_user.percentage_total
json.cards_to_revise cards do |card|
  json.id card.id
  json.word card.word
  json.english_m card.english_m
  json.french_m card.fr_m
  json.urdu_m card.urdu_m
  json.sura_id card.sura_id
  json.aya_id card.aya_id
  json.juzz_id card.juzz_id
  json.name_sura card.sura.name_phonetic
end