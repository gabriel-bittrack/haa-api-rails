class TimeLineSeed
  def self.seed
    Timeline.delete_all
    create_timelines
  end

  private
  def create_timelines
    TIME_LINES.each do |time|
      timeline = Timeline.create(decade: time)
    end
  end
  
  TIME_LINES = %w(
    1940
    1950
    1970
    1980
    1990
    2000
    2010
  )
end