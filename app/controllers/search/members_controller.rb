class Search::MembersController < ApplicationController
  def index
    @members = Member.search(params, params[:page])
  end
end
