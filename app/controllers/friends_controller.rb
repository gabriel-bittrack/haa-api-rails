class FriendsController < BaseApiController
  before_action :doorkeeper_authorize!
  
  def index
    data = { friends: 'Mike' }
    render json: data
  end
end
