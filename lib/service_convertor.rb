class ServiceConvertor
  def self.date_to_fr(date)
    Date.strptime(date.to_s, "%Y-%m-%d").strftime("%d/%m/%Y")
  end
end