class ScholarsController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    @scholars = Scholar.all
    respond_to do |format|
      format.json { render json: @scholars, each_serializer: ScholarSerializer }
      format.csv { send_data @scholars.to_csv(CSV_COLUMNS) }
    end
  end

  private
  CSV_COLUMNS = %w(
    id
    full_name
    first_name
    last_name
    high_school
    state
    city
    country
    scholar
    alumni
    specialized_scholar
    military_scholar
    scholar_standing
    military_branch
    undergraduate_institution
    undergraduate_degree
    undergraduate_major
    total_disbursement_allotment
    class_year
    ethnicity
    gender
  )
end
