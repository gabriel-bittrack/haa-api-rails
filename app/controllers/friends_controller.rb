class FriendsController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    @friends = Friend.all
    respond_to do |format|
      format.json { render json: @friends, each_serializer: FriendSerializer }
    end
  end
end
