class StatsController < ApplicationController

  def index

  end

  def explore

    if (["us", "ca"].include? params[:country])
      @country = params[:country]
    else
      @country = "us"
    end
    @states = States.instance.states[@country]

  end

  def get_cities
    @cities = City.where("country = ? AND state = ?", params[:country], params[:state])
    render json: @cities
  end

end
