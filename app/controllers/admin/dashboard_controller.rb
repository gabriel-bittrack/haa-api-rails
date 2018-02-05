class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_dashboard"

  def index
    @admins = Admin.all
    @admins
  end

  def create
    if current_user
      SalesforceImporterService.new(current_user: current_user).perform(type: 'members')
    end

    redirect_to :admin_dashboard_index
  end
end
