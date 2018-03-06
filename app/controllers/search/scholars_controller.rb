class Search::ScholarsController < ApplicationController
  def index
    @scholars = Scholar.search(params, params[:page])
    @scholar_class_years = Scholar.distinct_class_years
    @scholar_states = States.instance.states["usa"]
    
  end
end
