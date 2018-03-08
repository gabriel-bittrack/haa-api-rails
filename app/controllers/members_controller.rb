class MembersController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    # Use the application associated with the api token
    # to determine when the last time data was synced
    # with this particular device

    # @members = Member.all
    @members = Member.search(params, params[:page])
    # render json: @members, each_serializer: MemberSerializer
    respond_to do |format|
      format.json { paginate json: @members, each_serializer: MemberSerializer, per_page: 150 }
      # format.csv { send_data @members.to_csv(CSV_COLUMNS) }
    end
  end

  private
  CSV_COLUMNS = %w(
    id
    full_name
    first_name
    last_name
    gender
    relationship
    city
    state
    province
    country
    class_year
    industry
    current_org
    ethnicity
    military_branch
    short_bio
    bio
    web_url
    undergraduate_institution
    graduate_institution
    title
    profile_photo_url
    award_date
    quote
    date_of_death
  )

  def token
    token_param = request.headers[:Authorization].split(' ')
    token_param[1]
    @token ||= token_param[1]
  end

  def application
    @application ||= doorkeeper_token.application
  end
end
