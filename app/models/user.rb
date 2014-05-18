# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	has_one :api_key, dependent: :destroy
	has_many :interrogations
  has_many :cards, ->{ select("cards.*,interrogations.response, interrogations.next_date, interrogations.id as id_interrogation") },
       		 :through => :interrogations

    after_create :create_api_key


    def suras_statistics
      tab_surah ={};
      points_total_user = 0
      for i in 1..114
        tab_surah[i] = statistics_by_surah i
      end
      tab_surah

    end

    def sura_statistics(sura_id)
      tab_surah ={};
      points_total_user = 0
      statistics_by_surah sura_id
    end

    def add_card(card, response_value)
      if card.kind_of? Card

        #Initialisation
        spaced_repetition = SpacedRepetition.new response_value.to_i
        interrogation = Interrogation.new

        #Attribution des valeurs pour l'interrogation
        interrogation.next_date = spaced_repetition.next_repetition_date
        interrogation.user = self
        interrogation.card = card

        if  !interrogation.save
          raise "Ajout du mot impossible"
        end
      else
        raise "Le paramètre 'card' doit correspondre à une instance de type 'Card'"
      end


    end

  private

	    def create_api_key
	      ApiKey.create :user => self
      end

      def statistics_by_surah(sura_id)
        points_total_user = 0
        nb_cards = Card.where(:sura_id => sura_id).count
        points_total_sura = nb_cards * 3
        points_user = 0
        point1 = 0
        point2 = 0
        point3 = 0
        self.cards.where(:sura_id => sura_id).each do |card |
          points_user = points_user +  card.response
          if card.response == 1
            point1 = point1 + 1
          elsif card.response == 2
            point2 = point2 + 1
          elsif card.response == 3
            point3 = point3 + 1
          end

        end
        points_total_user = (points_user / points_total_sura * 100).round 2 unless points_user = 0

         return [points_total_user, point1, point2, point3]
      end
end
