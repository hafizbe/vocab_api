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
  has_many :cards, ->{ select("cards.*,interrogations.response, interrogations.next_date, interrogations.date_response, interrogations.id as id_interrogation") },
       		 :through => :interrogations

    after_create :create_api_key

    # Détermine toutes les cartes connus en fonction de la sourate
    def cards_known(sura_id)
      tab_retour = []
      cards_for_user = self.cards.includes(:interrogations).where(:sura_id => sura_id)
      cards_for_user_ids = cards_for_user.ids

      cards_for_user.each do |card|
        tab_retour << card.attributes.merge({"response"=>card.response}).merge({"sura_id" => card.id})
        .merge({"date_response" => card.date_response})
      end

      if cards_for_user_ids.empty?
        cards_for_user_ids = ''
      end

      cards_for_sura = Card.where.not(id: cards_for_user_ids).where(:sura_id => sura_id)
      cards_for_sura.each do |card|

        tab_retour << card.attributes.merge({"response"=> 0}).merge({"sura_id" => card.id})
      end
      tab_retour
    end


    # Affiche les statistiques de toutes les sourates
    def suras_statistics
      tab_surah =[];
      points_total_user = 0
      Sura.all.each do |sura|
        tab_surah << statistics_by_sura(sura.id).merge("sura_id" => sura.id).merge("name_phonetic" => sura.name_phonetic).merge("name_arabic" => sura.name_arabic)
      end
      tab_surah

    end
    # Affiche les statistiques d'une sourate
    def sura_statistics(sura_id)
      tab_surah ={};
      points_total_user = 0
      statistics_by_sura sura_id
    end


    # Ajoute une carte pour l'utilisateur
    def add_card(card, response_value)
      if card.kind_of? Card

        #Initialisation
        spaced_repetition = SpacedRepetition.new response_value.to_i
        interrogation = Interrogation.new

        #Attribution des valeurs pour l'interrogation
        interrogation.next_date = spaced_repetition.next_repetition_date
        interrogation.user = self
        interrogation.card = card
        interrogation.response = response_value
        interrogation.date_response = Time.now

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

      def statistics_by_sura(sura_id_param)
        points_total_user = 0
        nb_cards = Card.where(:sura_id => sura_id_param).count
        points_total_sura = nb_cards * 3
        points_user = 0
        point1 = 0
        point2 = 0
        point3 = 0
        sura_id = nil
        self.cards.where(:sura_id => sura_id_param).all.each do |card |
          points_user = points_user +  card.response
          if card.response == 1
            point1 = point1 + 1
          elsif card.response == 2
            point2 = point2 + 1
          elsif card.response == 3
            point3 = point3 + 1
          end
          sura_id = card.sura_id

        end
        points_total_user = (points_user.to_f / points_total_sura * 100).round 2 unless points_user == 0

         return   {'points_total_user'=> points_total_user, 'point1' => point1, 'point2' => point2, 'point3' => point3}
      end
end
