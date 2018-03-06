module Search::MembersHelper
  def years
    (1947..2018).map do |year|
      { name: year, value: year }
    end
  end

  def states
    States.instance.states["usa"]
  end

  def industries
    Member.distinct_industries
  end
end