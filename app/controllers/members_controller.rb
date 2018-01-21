class MembersController < ApplicationController
  def index
    @members = Member.all
    render json: @members, each_serializer: MemberSerializer
  end
end
