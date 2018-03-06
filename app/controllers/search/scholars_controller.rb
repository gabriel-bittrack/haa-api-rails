class Search::ScholarsController < ApplicationController
  def index
    @scholars = Scholar.search(params, params[:page])
  end
end
