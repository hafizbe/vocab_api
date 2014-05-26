class ServiceCalculator
  def self.percentage_sura(nb_cards, points)
    total = 0
    unless points == 0
      total = (points.to_f / (nb_cards * 3).to_f * 100).round 2
    end

    total
  end
end