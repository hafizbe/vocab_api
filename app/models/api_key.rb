# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ApiKey < ActiveRecord::Base

    belongs_to :user

    before_create :generate_token

    private

    def generate_token
      begin
        self.token = SecureRandom.hex.to_s
      end while self.class.exists?(token: token)
    end

  end
