class Search::MembersController < ApplicationController
  layout "bio"
  def index
    @members = Member.search(params, params[:page])
    @years = years
    @states = states
    @industries = industries
  end

  def show
    @member = Member.find_by(id: params[:id])
    @years = years
    @states = states
    @industries = industries
  end

  private

  def years
    Member.distinct_class_years
  end

  def states
    States.instance.states["us"]
  end

  def industries
    Member.distinct_industries
  end
end
