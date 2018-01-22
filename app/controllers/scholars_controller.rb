class ScholarsController < ApplicationController
  def index
    @scholars = Scholar.all
    render json: @scholars, each_serializer: ScholarSerializer
  end
end
