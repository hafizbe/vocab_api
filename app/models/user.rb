class User < ActiveRecord::Base
	has_one :api_key, dependent: :destroy
	has_many :interrogations
  	has_many :cards, ->{ select("cards.*,interrogations.response, interrogations.next_date, interrogations.id as id_interrogation") },
       		 :through => :interrogations

    after_create :create_api_key

    private

	    def create_api_key
	      ApiKey.create :user => self
	    end
end
