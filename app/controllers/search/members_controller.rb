class Search::MembersController < ApplicationController

  def index
    @limit = 9
    @links = 2
    @page = params[:page].to_i

    puts ">>>> What are params for member search : #{params.inspect}"

    if not params[:s].nil?
      @where = "full_name like '#{params[:s]}%'"
      @query = "&s=#{params[:s]}"
    end

    @total = Member.where(@where).count()
    @last = (@total / @limit).ceil
    @start = ((@page - @links) > 0) ? @page - @links : 1
    @end = ((@page + @links) < @last) ? @page + @links : @last

    if params[:page].nil? || params[:page].to_i < 1
      @members = Member.where(@where).limit(@limit)
      @page = 1
    else
      @members = Member.where(@where).offset((@page - 1) * @limit).limit(@limit)
    end
  end

end
