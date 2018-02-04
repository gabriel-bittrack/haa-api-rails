class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_dashboard"

  def index
    @admins = Admin.all
  end
end
