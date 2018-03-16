class StatsController < ApplicationController

  def index

  end

  def update_map
    puts ">>>> params : #{params}"
  end

  def explore
    puts ">>>>>> params from explore: #{params}"
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
    @members = Member.where("state = ?", params[:state])
    puts ">>>> found members : #{@members.inspect}"
    render json: @cities
  end

  def get_search_results
    @cities = City.where("country = ? AND state = ?", params[:country], params[:state])
    #@members = Member.where("city = ? AND state = ?", params[:city], params[:state])
    @members = Member.map_search(params)
    @scholars = Scholar.map_search(params)
    @selected_state = States.instance.find_us_state_by_code(params[:state]) if params[:state].present?

    render json: {
      cities: @cities,
      selected_state: @selected_state,
      members: @members.as_json(options: { count: @members.length }),
      scholars: @scholars.as_json(options: {count: @scholars.length }),
    }
  end

end
