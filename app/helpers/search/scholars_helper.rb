module Search::ScholarsHelper
  def scholar_class_years
    Scholar.distinct_class_years
  end

  def scholar_states
    States.instance.states["usa"]
  end
end