class HomeController < ApplicationController
  def landing
    Rails.logger.info("Inside the landing method")
    if current_user
      Rails.logger.info("We have a current user, proceed : #{current_user}")
      client = Restforce.new oauth_token: current_user.oauth_token,
        refresh_token: current_user.refresh_token,
        instance_url: current_user.instance_url,
        client_id: ENV['SALESFORCE_APP_ID'],
        client_secret: ENV['SALESFORCE_APP_SECRET'],
        authentication_callback: Proc.new { |x| puts ">>>> x.to_s" }
    end
  end
end
