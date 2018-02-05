class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_dashboard"

  def index
    @admins = Admin.all
    @admins
  end

  def create
    if current_user
      puts ">>>>> what are the protected_params : #{protected_params.inspect}"
      SalesforceImporterService.new(current_user: current_user).perform(type: protected_params)
    end

    redirect_to :admin_dashboard_index
  end

  private

  def protected_params
    params.require(:sync_type)
  end
end
