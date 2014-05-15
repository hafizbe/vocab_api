cards ||= @cards

json.array! cards do |card|
    json.content_arabic card.content_ar
    json.sura_id card.sura_id

end