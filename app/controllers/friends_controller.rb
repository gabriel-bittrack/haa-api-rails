class FriendsController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    @friends = Friend.search(params, params[:page])
    respond_to do |format|
      format.json { paginate json: @friends, each_serializer: FriendSerializer, per_page: 1000 }
    end
  end

  private
  CSV_COLUMNS = %w(
    id
    full_name
    first_name
    last_name
    title
    current_org
    city
    state
    country
    profile_image_file_name
    profile_image_content_type
    profile_image_file_size
  )
end
