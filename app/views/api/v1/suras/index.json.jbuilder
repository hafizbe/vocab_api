suras ||= @suras

json.array! suras do |sura|
    json.name_arabic sura.name_arabic
    json.name_phonetic sura.name_phonetic

end