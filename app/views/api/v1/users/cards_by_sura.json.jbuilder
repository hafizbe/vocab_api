cards ||= @cards

json.sura_name_phonetic cards["sura_name_phonetic"]
json.percentage_sura cards["percentage_sura"]
json.point1 cards["point1"]
json.point2 cards["point2"]
json.point3 cards["point3"]
json.nb_cards_unknown cards["nb_cards_unknown"]
json.nb_cards cards["nb_cards"]
json.cards  cards["cards"]

#json.array! cards do |card|


