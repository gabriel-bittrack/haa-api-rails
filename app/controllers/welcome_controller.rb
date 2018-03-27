class WelcomeController < ApplicationController
  def index
    @members = Member.search(params, params[:page])
    @years = years
    @states = states
    @industries = industries
  end

  private

  def years
    Member.distinct_class_years.reverse
  end

  def states
    States.instance.states["us"]
  end

  def industries
    Member.distinct_industries
  end
end
