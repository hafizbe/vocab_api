cards ||= @cards

json.array! cards do |card|
  json.id card.id
  json.word card.word
  json.english_m card.english_m
  json.urdu_m card.urdu_m
  json.sura_id card.sura_id
  json.aya_id card.aya_id
  json.juzz_id card.juzz_id
  json.sura_name card.sura.name_phonetic
end