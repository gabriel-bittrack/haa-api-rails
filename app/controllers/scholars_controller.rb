class ScholarsController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    @scholars = Scholar.search(params, params[:page])
    @csv_scholars = Scholar.all
    respond_to do |format|
      format.json { paginate json: @scholars, each_serializer: ScholarSerializer, per_page: 1000 }
      format.csv { send_data @csv_scholars.to_csv(CSV_COLUMNS) }
    end
  end

  private
  CSV_COLUMNS = %w(
    id
    full_name
    first_name
    last_name
    scholar_standing
    city
    state
    country
    lat
    lng
    ethnicity
    gender
    photo
    alumni
    specialized_scholar
    military_scholar
    total_disbursement_allotment
    class_year
    date_of_birth
    high_school
    undergraduate_institution
    post_graduate_institution
    secondary_graduate_institution
    under_graduate_studies
    post_graduate_studies
    secondary_graduate_studies
  )
end
