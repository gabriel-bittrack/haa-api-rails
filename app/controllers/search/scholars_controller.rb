class Search::ScholarsController < ApplicationController
  def index
    @scholars = Scholar.search(params, params[:page])
    @years = years
    @states = states
  end

  def show
    @scholar = Scholar.find_by(id: params[:id])
    @scholar_bio = static_bio
    @years = years
    @states = states
  end

  private

  def static_bio
    "Horatio Alger Members support promising young people with the resources and confidence needed to overcome adversity and pursue their dreams through higher education. As one of the largest need-based college scholarship providers in North America, the Horatio Alger Association assists high school students who have faced and overcome great obstacles in their young lives. While many scholarship programs are directed primarily to recognizing academic achievement or leadership potential, the Horatio Alger Scholarship Program supports students who have critical financial and have exhibited determination, integrity, and perseverance in overcoming adversity."
  end

  def years
    Scholar.distinct_class_years.reverse
  end

  def states
    States.instance.states["us"]
  end
end
