class Api::V1::UsersController < ApplicationController

  before_filter :restrict_access
  respond_to :json
  def get_cards_known
    @cards = @current_user.cards_known
    respond_with @cards
  end



end
