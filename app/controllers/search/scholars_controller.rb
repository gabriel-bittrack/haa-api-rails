class Search::ScholarsController < ApplicationController

  def index
    @limit = 9
    @links = 2

    @page = params[:page].to_i

    if not params[:s].nil?
      @where = "full_name like '#{params[:s]}%'"
    end

    @total = Scholar.where(@where).count()
    @last = (@total / @limit).ceil
    @start = ((@page - @links) > 0) ? @page - @links : 1
    @end = ((@page + @links) < @last) ? @page + @links : @last


    if params[:page].nil? || params[:page].to_i < 1
      @scholars = Scholar.where(@where).limit(@limit)
      @page = 1
    else
      @scholars = Scholar.where(@where).offset((@page - 1) * @limit).limit(@limit)
    end
  end

end
