

class Api::V1::SurasController < ApplicationController
  before_filter :restrict_access

  respond_to :json

  def index
    @suras = Sura.all
    respond_with @suras


  end

  def show
  end
end
