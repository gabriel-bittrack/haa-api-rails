class StatsController < ApplicationController

  def index

  end

  def explore
    if (["us", "ca"].include? params[:country])
      @country = params[:country]
    else
      @country = "us"
    end
    @states = States.instance.states[@country]
  end

  def history

  end

  def demographics
    if (["members", "scholars"].include? params[:type])
      @type = params[:type]
    else
      @type = "members"
    end
    @ethnicity = [
        { name: "African-American or Black", percent: "35"},
        { name: "Asian or Pacific Islander", percent: "17" },
        { name: "Caucasian or White", percent: "23" },
        { name: "Hispanic or Latino", percent: "40" },
        { name: "Other", percent: "15" }
      ];

    @industry = [
        { name: "Marketing", percent: "35"},
        { name: "Manufacturing", percent: "17" },
        { name: "Healthcare", percent: "23" },
        { name: "Media", percent: "40" },
        { name: "Tech", percent: "15" },
        { name: "Other", percent: "12" }
      ];

    @age = [
        { name: "18-24", percent: "3"},
        { name: "25-34", percent: "5" },
        { name: "35-44", percent: "22" },
        { name: "45-54", percent: "35" },
        { name: "55-64", percent: "25" },
        { name: "65-74", percent: "22" },
        { name: "75-84", percent: "10" }
      ];
  end

  def get_cities
    @cities = City.where("country = ? AND state = ?", params[:country], params[:state])
    render json: @cities
  end

end
