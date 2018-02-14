require "open-uri"
require "net/http"

class SalesforceImporterService
  require 'nokogiri'

  def initialize(current_user:)
    @current_user = current_user
  end

  def perform(type:)
    puts "running perform with type: #{type}"
    case type
    when "members"
      delete_all_members
      process_members(client.query(member_sql_statement))
    when "scholars"
      delete_all_scholars
      process_scholars(client.query(scholar_sql_statement))
    else
      "Nothing to process"
    end
  end

  private

  def process_scholars(scholars)
    scholars_array = []

    scholars.each do |scholar|
      scholars_array << {  
        full_name: scholar.Name,
        first_name: scholar.FirstName,
        last_name: scholar.LastName,
        high_school: scholar.High_School__c,
        state: scholar.PPA_State__c,
        city: scholar.PPA_City__c,
        country: scholar.PPA_Country__c,
        scholar: scholar.Association_Scholar__c,
        alumni: scholar.Association_Alumni__c,
        specialized_scholar: scholar.Association_Military_Scholar__c,
        undergraduate_institution: scholar.Undergraduate_Studies_Institution__c,
        undergraduate_degree: scholar.Undergraduate_Studies_Major__c,
        total_disbursement_allotment: scholar.Total_Disbursement_Allotment__c
    }
    end
    ScholarImporterWorker.perform_async(scholars_array)

  end

  def extract_profile_image(tag_fragment)
    document = Nokogiri::XML::DocumentFragment.parse(tag_fragment)
    node = document.at_css('img')
    node['src']
  end

  def process_members(members)
    members.each do |account|
      image_url = extract_profile_image(account.Main_Profile_Picture__c) if account.Main_Profile_Picture__c

      member = Member.create(
        full_name: account.Name,
        first_name: account.FirstName,
        last_name: account.LastName,
        profile_photo_url: account.Image_url__c,
        city: account.PPA_City__c,
        state: account.PPA_State__c,
        province: account.PPA_Country__c,
        country: account.PPA_Country__c,
        gender: account.Gender__c,
        relationship: nil,
        industry: account.Industry__c,
        current_org: account.Current_Organization__c,
        title: account.Title,
        short_bio: account.Bio_Short__c,
        web_url: account.Member_Web_Video_Url__c,
        undergraduate_institution: account.Undergraduate_Studies_Institution__c,
        graduate_institution: account.PostGraduate_Studies_Institution__c,
        profile_photo_url: image_url
      )

      if (image_url)
        MemberProfileImageWorker.perform_async(image_url, member.id)
      end
    end
  end

  def delete_all_members
    Member.delete_all
  end

  def delete_all_scholars
    Scholar.delete_all
  end

  def client
    @client ||= Restforce.new :oauth_token => @current_user.oauth_token,
      :refresh_token => @current_user.refresh_token,
      :instance_url => @current_user.instance_url,
      :client_id => ENV['SALESFORCE_APP_ID'],
      :client_secret => ENV['SALESFORCE_APP_SECRET']
  end

  def member_sql_statement
    @sql_statement ||= "select " + MEMBER_FIELDS.join(",") + " from Contact where RecordType.Name IN ('Member') AND Association_Member__c = true"
  end

  def scholar_sql_statement
    @scholar_sql_statement ||= "select " + SCHOLAR_FIELDS.join(",") + " from Contact where RecordType.Name IN ('Scholar') LIMIT 500"
  end

  SCHOLAR_FIELDS =
    %w(
      Name
      FirstName
      LastName
      High_School__c
      PPA_State__c
      PPA_City__c
      PPA_Country__c
      Association_Scholar__c
      Association_Alumni__c
      Association_Specialized_Scholar__c
      Association_Military_Scholar__c
      Scholar_Standing__c
      Military_Service_Military_Branch__c
      Undergraduate_Studies_Institution__c
      Undergraduate_Studies_Major__c
      Total_Disbursement_Allotment__c
    )

  MEMBER_FIELDS =
    %w(
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
      Main_Profile_Picture__c
      Profile_Picture__c
    ).freeze
end
