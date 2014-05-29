class Api::V1::CardsController < ApplicationController
  before_filter :restrict_access
  respond_to :json

  def show
    unless (params[:id].nil?)
      @card = Card.find(params[:id])
      respond_with @card
    end
  end
end
