module Search::ScholarsHelper
  def scholar_class_years
    Scholar.distinct_class_years
  end
end