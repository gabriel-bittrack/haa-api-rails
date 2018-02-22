class StatsController < ApplicationController

  def index

  end

  def explore
    @country = params[:country]
    @states = States.instance.states[@country]

  end

  def get_cities
    @cities = City.where("country = ? AND state = ?", params[:country], params[:state])
    render json: @cities
  end

end
