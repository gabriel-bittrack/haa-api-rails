class ScholarsController < BaseApiController
  before_action :doorkeeper_authorize!
  
  def index
    @scholars = Scholar.all
    render json: @scholars, each_serializer: ScholarSerializer
  end
end
