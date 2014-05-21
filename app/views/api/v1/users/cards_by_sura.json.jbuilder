cards ||= @cards

json.array! cards do |card|
  json.id card["id"]
  json.word card["word"]
  json.english_m card["english_m"]
  json.response card["response"]
  json.word card["word"]
  json.date_response card["date_response"]
end

