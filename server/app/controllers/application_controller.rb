class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _|
      Token.find_by(token: token)
    end
  end
end
