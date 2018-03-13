class DonationsController < BaseApiController
  before_action :doorkeeper_authorize!

  def index
    # donations = ScholarScholarship.all
    @sudo_donations = {
      "1980s": ScholarScholarship.sum_eighties,
      "1990s": ScholarScholarship.sum_nineties,
      "2000s": ScholarScholarship.sum_two_thousands,
      "2010s": ScholarScholarship.sum_two_thousand_tens,
      "all_time": ScholarScholarship.sum_all_time
    }

    puts ">>> donations : #{@sudo_donations}"
    render :json => @sudo_donations
  end
end
