include ActionController::HttpAuthentication::Token::ControllerMethods
include ActionController::MimeResponds
include ActionController::ImplicitRender

class ApplicationController < ActionController::API

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

	  private

    def restrict_access
      unless restrict_access_by_params || restrict_access_by_header
        render json: {message: 'Invalid API Token'}, status: 401
        return
      end

      @current_user = @api_key.user if @api_key
    end

    def restrict_access_by_header
      return true if @api_key

      authenticate_with_http_token do |token|
        @api_key = ApiKey.find_by_token(token)
      end
    end

    def restrict_access_by_params
      return true if @api_key
      
      @api_key = ApiKey.find_by_token(params[:token])
    end

end
