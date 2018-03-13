class Search::ScholarsController < ApplicationController
  def index
    @scholars = Scholar.search(params, params[:page])
    @years = years
    @states = states
  end

  def show
    @scholar = Scholar.find_by(id: params[:id])
    @years = years
    @states = states
  end

  private

  def years
    Scholar.distinct_class_years
  end

  def states
    States.instance.states["us"]
  end
end
