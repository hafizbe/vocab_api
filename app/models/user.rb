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
  has_many :cards, ->{ select("cards.*,interrogations.response, interrogations.next_date, interrogations.date_response,
                               interrogations.id as id_interrogation") },
       		 :through => :interrogations

    after_create :create_api_key


  # Récupère toutes les dates à réviser
  def cards_of_today
    self.cards.where("interrogations.next_date <= ?", Date.today)
  end

  # Indique le % de compréhension du Quran
  def percentage_total
    (self.cards.where("interrogations.response = ?", 5).length.to_f / Card.count).round 2
  end

  # Défini le pourcentage de connaissance pour la sourate en paramètre
    def nb_points_by_sura(sura_id)
      points_user = 0
      point1 = 0
      point2 = 0
      point3 = 0
      nb_cards = Card.where(:sura_id =>  sura_id).count
      self.cards.where(:sura_id => sura_id).all.each do |card|
        points_user = points_user +  card.response
        if card.response == 0
          point1 = point1 + 1
        elsif card.response == 3
          point2 = point2 + 1
        elsif card.response == 5
          point3 = point3 + 1
        end
      end
      ServiceCalculator.percentage_sura nb_cards, points_user
    end


    #Récupère les cartes  non apprises pour une sourate donnée
    def cards_unknown(sura_id)
      cards_for_user_ids =  self.cards.where(:sura_id => sura_id).ids
      cards_unknown = Card.where.not(id: cards_for_user_ids).where(:sura_id => sura_id)
    end

    # Détermine toutes les cartes connus en fonction de la sourate
    def cards_known(sura_id)
      tab_retour = {"cards" => []}
      cards_for_user = self.cards.includes(:interrogations).where(:sura_id => sura_id)
      cards_for_user_ids = cards_for_user.ids
      point1 = 0
      point2 = 0
      point3 = 0
      nb_cards = 0
      points_user = 0
      cards_for_user.each do |card|
        points_user = points_user + card.response
        nb_cards  = nb_cards + 1
        case card.response
          when 0
            point1 = point1 + 1
          when 3
            point2 = point2 + 1
          when 5
            point3 = point3 + 1
        end
        date_response = card.date_response
        date_response = ServiceConvertor.date_to_fr(card.date_response) unless card.date_response.nil?
        tab_retour["cards"] << card.attributes.merge({"response"=>card.response}).merge({"sura_id" => card.id})
        .merge({"date_response" => date_response})
      end
      tab_retour["point1"] = point1
      tab_retour["point2"] = point2
      tab_retour["point3"] = point3

      if cards_for_user_ids.empty?
        cards_for_user_ids = ''
      end

      cards_for_sura = Card.where.not(id: cards_for_user_ids).where(:sura_id => sura_id)
      nb_cards_unknown  = 0
      cards_for_sura.each do |card|
        nb_cards_unknown = nb_cards_unknown + 1
        nb_cards  = nb_cards + 1
        tab_retour["cards"] << card.attributes.merge({"response"=> -1}).merge({"sura_id" => card.sura_id})
      end
      tab_retour["nb_cards_unknown"] = nb_cards_unknown
      tab_retour["nb_cards"] = nb_cards
      tab_retour["percentage_sura"] = ServiceCalculator.percentage_sura nb_cards, points_user
      tab_retour["sura_name_phonetic"] = Sura.find(sura_id).name_phonetic
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
        spaced_repetition = SpacedRepetition::Sm2.new response_value.to_i
        interrogation = Interrogation.new

        #Attribution des valeurs pour l'interrogation
        interrogation.next_date = spaced_repetition.next_repetition_date
        interrogation.user = self
        interrogation.card = card
        interrogation.response = response_value
        interrogation.date_response = Time.now
        interrogation.easiness_factor = spaced_repetition.easiness_factor
        interrogation.next_interval = spaced_repetition.interval

        if  !interrogation.save
          raise "Ajout du mot impossible"
        end
      else
        raise "Le paramètre 'card' doit correspondre à une instance de type 'Card'"
      end

      #interrogation.attributes.merge({"percentage_sura" => self.nb_points_by_sura(card.sura_id)})
      interrogation
    end

    # Met à jour la carte. Il s'agit ici d'une révision, et pas d'un apprentissage.
    def update_card(response, card_id)
      interrogation = Interrogation.where(:card_id => card_id, :user_id => self.id).first

      unless interrogation.nil?
        interrogation.revision response
      else
        raise "Interrogation introuvable"
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
          if card.response == 0
            point1 = point1 + 1
          elsif card.response == 3
            point2 = point2 + 1
          elsif card.response == 5
            point3 = point3 + 1
          end
          sura_id = card.sura_id

        end
        points_total_user = (points_user.to_f / points_total_sura * 100).round 2 unless points_user == 0

         return   {'points_total_user'=> points_total_user, 'point1' => point1, 'point2' => point2, 'point3' => point3,
                  'nb_cards' => nb_cards}
      end


end
