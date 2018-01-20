class MembersController < ApplicationController
  def index
    data = { test: 'Mike' }
    render json: data
  end
end
