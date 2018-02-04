class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_dashboard"

  FIELDS = %w(
    Name
    FirstName
    LastName
    PPA_City__c
    PPA_State__c
    PPA_Country__c
    haa_Race__c
    Gender__c
    Non_Member_Type__c
    Industry__c
    Current_Organization__c
    Title
    Bio_Short__c
    Military_Service_Military_Branch__c
    Member_Web_Video_Url__c
    Undergraduate_Studies_Institution__c
    PostGraduate_Studies_Institution__c
  ).freeze

  def index
    @admins = Admin.all
    @admins
  end

  def create
    if current_user
      Rails.logger.info("We have a current user, proceed : #{current_user}")
      client = Restforce.new :oauth_token => current_user.oauth_token,
        :refresh_token => current_user.refresh_token,
        :instance_url => current_user.instance_url,
        :client_id => ENV['SALESFORCE_APP_ID'],
        :client_secret => ENV['SALESFORCE_APP_SECRET']

      sql_statement = "select " + FIELDS.join(",") + " from Contact where RecordType.Name IN ('Member')"
      puts "Querying using query: #{sql_statement}"
      accounts = client.query(sql_statement)

      Member.delete_all

      accounts.each do |account|
        member = Member.create(
          full_name: account.Name,
          first_name: account.FirstName,
          last_name: account.last_name,
          profile_photo_url: account.Image_url__c,
          city: account.PPA_City__c,
          state: account.PPA_State__c,
          province: account.PPA_Country__c,
          country: account.PPA_Country__c,
          gender: account.Gender__c,
          relationship: account.Current_Organization__c,
          industry: account.Industry__c,
          current_org: account.Current_Organization__c,
          title: account.Title,
          short_bio: account.Bio_Short__c,
          web_url: account.Member_Web_Video_Url__c,
          undergraduate_institution: account.Undergraduate_Studies_Institution__c,
          graduate_institution: account.PostGraduate_Studies_Institution__c,
        )
      end
    end

    redirect_to :admin_dashboard_index
  end

  def fetch_salesforce_data
    if current_user

    end

  end

  def test_ajax
    puts "You made it!"
    @ajax_response = "You made it!"

    respond_to do |f|
      f.js
    end
  end
end
