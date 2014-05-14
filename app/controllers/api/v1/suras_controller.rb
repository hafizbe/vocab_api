class Api::V1::SurasController < ApplicationController

	before_filter :restrict_access

  def index
  	@suras = Sura.all

  	render json: {message: @suras}, status: 200
  end

  def show
  end
end
