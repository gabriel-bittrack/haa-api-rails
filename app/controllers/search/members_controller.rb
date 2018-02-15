class Search::MembersController < ApplicationController

  def index
    @limit = 9
    @links = 2
    @total = Member.count()
    @page = params[:page].to_i
    @last = (@total / @limit).ceil
    @start = ((@page - @links) > 0) ? @page - @links : 1
    @end = ((@page + @links) < @last) ? @page + @links : @last

    if params[:page].nil? || params[:page].to_i < 1
      @members = Member.limit(@limit)
      @page = 1
    else
      @members = Member.offset((@page - 1) * @limit).limit(@limit)
    end
  end

end
