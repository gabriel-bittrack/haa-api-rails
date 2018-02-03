class CustomApplicationsController < Doorkeeper::ApplicationsController
  before_action :authenticate_admin!

  # def index
  #   puts ">>>> current_user in controller : #{current_admin.inspect}" if current_admin
  #   puts ">>>> is admin signed in : #{admin_signed_in?}"
  #   @applications = []
  # end
end
