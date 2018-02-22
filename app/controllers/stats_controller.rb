class StatsController < ApplicationController

  def index

  end

  def explore
    @country = params[:country]
    @states = States.instance.states[@country]

  end
end
