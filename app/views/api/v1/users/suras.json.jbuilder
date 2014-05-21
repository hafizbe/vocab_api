statistics ||= @statistics

json.array! statistics do |statistic|
  json.sura_id statistic["sura_id"]
  json.points_total_user statistic["points_total_user"]
  json.point1 statistic["point1"]
  json.point2 statistic["point2"]
  json.point3 statistic["point3"]

end
