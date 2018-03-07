class BaseApiController < ActionController::Base
  include Rails::Pagination
  
  private
  def token
    token_param = request.headers[:Authorization].split(' ')
    token_param[1]
    @token ||= token_param[1]
  end

  def authenticated_application
    @application ||= doorkeeper_token.application
  end

  helper_method :authenticated_application
end
