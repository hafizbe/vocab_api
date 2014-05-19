class Api::V1::UsersController < ApplicationController

  before_filter :restrict_access
  respond_to :json

  def cards
    @cards = @current_user.cards
    respond_with @cards
  end

  def suras
    @statistics = @current_user.suras_statistics
    respond_with @statistics
  end

  def create_interrogation
    unless (params[:card_id].nil? or params[:response].nil?)
      card = Card.find params[:card_id]
      @current_user.add_card card, params[:response]
    else
      raise "Les paramètres sont manquants"
    end
  end

  def cards_by_sura
    unless params[:sura_id].nil?
      @cards = @current_user.cards_known params[:sura_id]
      respond_with @cards
    else
      raise "Le paramètre de la sourate est manquant"
    end

  end

end
