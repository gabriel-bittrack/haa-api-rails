class FriendsController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    data = { friends: 'Mike' }
    render json: data
    @friends = Friend.all
    # render json: @members, each_serializer: MemberSerializer
    respond_to do |format|
      format.json { render json: @friends, each_serializer: FriendSerializer }
      # format.csv { send_data @friends.to_csv(CSV_COLUMNS) }
    end
  end
end
