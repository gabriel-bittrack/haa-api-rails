class FriendsController < ApplicationController
  def index
    data = { friends: 'Mike' }
    render json: data
  end
end
