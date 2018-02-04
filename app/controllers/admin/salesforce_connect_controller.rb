class Admin::SalesforceConnectController < ApplicationController
  def create
    puts "Put code to fetch SalesForce data here!"
    @ajax_response = "Put code to fetch Salesforce data here!"

    respond_to do |f|
      redirect_to dashboard_url
      f.js
    end
  end
end
