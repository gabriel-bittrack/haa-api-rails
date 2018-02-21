class StatsController < ApplicationController

  def index

  end

  def explore
    @country = params[:country]
    if @country == "usa"
      @states = States.instance.states[:usa]
    else
      @states = States.instance.states[:canada]
    end

  end
end
