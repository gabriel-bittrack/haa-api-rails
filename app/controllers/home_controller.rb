class HomeController < ApplicationController
  def landing
    Rails.logger.info("Inside the landing method")
    if current_user
      Rails.logger.info("We have a current user, proceed : #{current_user}")
      client = Restforce.new :oauth_token => current_user.oauth_token,
        :refresh_token => current_user.refresh_token,
        :instance_url => current_user.instance_url,
        :client_id => ENV['SALESFORCE_APP_ID'],
        :client_secret => ENV['SALESFORCE_APP_SECRET']

      accounts = client.query("select Id, Name, Contact.FirstName, Contact.LastName, Email, Image_URl__c, Member_Web_Video_Url__c, Main_Profile_Picture__c from Contact")

      accounts.each do |account|
        puts "Found : #{account.inspect}"
      end

      @account = accounts.first
    end
  end

  def members

  end

  def scholars

  end
end
