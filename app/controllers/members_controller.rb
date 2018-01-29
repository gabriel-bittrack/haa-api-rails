class MembersController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    # Use the application associated with the api token
    # to determine when the last time data was synced
    # with this particular device

    @members = Member.all
    render json: @members, each_serializer: MemberSerializer
  end

  private

  def token
    token_param = request.headers[:Authorization].split(' ')
    token_param[1]
    @token ||= token_param[1]
  end

  def application
    @application ||= doorkeeper_token.application
  end
end
