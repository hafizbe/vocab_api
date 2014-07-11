class Api::V1::UsersController < ApplicationController

  before_filter :restrict_access, :except => [:authenticate, :create]
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
      @interrogation = @current_user.add_card card, params[:response]
      respond_with @interrogation
    else
      raise "Les paramètres sont manquants"
    end
  end

  def update_interrogation
    @interrogation = @current_user.update_card params[:response], params[:card_id]
    respond_with @interrogation
  end

  def cards_to_work
    @cards = @current_user.cards_unknown params[:sura_id]
    respond_with @cards
  end

  def cards_by_sura
    unless params[:sura_id].nil?
      @cards = @current_user.cards_known params[:sura_id]
      respond_with @cards
    else
      raise "Le paramètre de la sourate est manquant"
    end

  end

  def statistics_home
    @cards = @current_user.cards_of_today
    respond_with @cards
  end

  def authenticate
    user = User.authenticate(params[:email], params[:password])
    unless user.nil?
      render json: {message: user.api_key.token}, status: 200
    else
      render json: {message: 'Invalid login or password'}, status: 401
    end
  end

  def create
    user = User.new(:email => params[:email], :password => params[:password], :name => params[:pseudo])
    if user.save
      render json: {message: user.api_key.token, success: true}, status: 200
    else
      render json: {message: user.errors, success: false}, status: 200
    end
  end

end
