class ScholarsController < ApplicationController
  def index
    data = { scholar: 'Mike' }
    render json: data
  end
end
