require 'nokogiri'
require 'mapbox-sdk'

Mapbox.access_token = ENV.fetch("MAPBOX_TOKEN")

class MemberProcessor < SyncProcessor
  API_RATE_LIMIT = 100
  TIME_TO_WAIT = 120

  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    delete
    process_members(client.query(member_sql_statement))
  end

  private
  def extract_profile_image(tag_fragment)
    document = Nokogiri::XML::DocumentFragment.parse(tag_fragment)
    node = document.at_css('img')
    node['src']
  end

  def member_sql_statement
    @sql_statement ||= "select " + MEMBER_FIELDS.join(",") + " from Contact where RecordType.Name IN ('Member') AND Association_Member__c = true"
  end

  def delete
    Member.delete_all
  end

  def member_city(member)
    city = ''
    if member.PPA_City__c
      city = member.PPA_City__c
    elsif member.Home_Address_City__c
      city = member.Home_Address_City__c
    elsif member.Business_City__c
      city = member.Business_City__c
    end
    city
  end

  def member_title(member)
    member.haa_Date_of_Death__c ? member.Title_Current_Primary__c : member.Title_Induction_Primary__c
  end

  def process_members(members)
    member_queue = []

    members.each do |account|
      image_url = extract_profile_image(account.Main_Profile_Picture__c) if account.Main_Profile_Picture__c

      # determine which title to use, based on them being alive
      current_title = account.haa_Date_of_Death__c ? account.Title_Current_Primary__c : account.Title_Induction_Primary__c

      member = Member.create(
        full_name: account.Name,
        first_name: account.FirstName,
        last_name: account.LastName,
        profile_photo_url: account.Image_url__c,
        city: account.PPA_City__c,
        state: account.PPA_State__c,
        zipcode: account.Primary_Affiliation_Zip_Postal_Code__c,
        province: account.PPA_Country__c,
        country: account.PPA_Country__c,
        gender: account.Gender__c,
        industry: account.Industry__c,
        current_org: account.Organization_Current_Primary_Name__c,
        title: member_title(account),
        bio: account.Bio__c,
        class_year: account.Member_Class_Year__c,
        web_url: account.Member_Web_Video_Url__c,
        undergraduate_institution: account.Undergraduate_Studies_Institution__c,
        graduate_institution: account.PostGraduate_Studies_Institution__c,
        profile_photo_url: image_url,
        quote: account.Member_Web_Quote__c,
        date_of_death: account.haa_Date_of_Death__c,
        ethnicity: account.haa_Race__c,
        sf_id: account.Id,
        active_military: account.Active_Military_or_Veteran__c
      )

      member_queue << member.id

      if (image_url)
        MemberProfileImageWorker.perform_async(image_url, member.id)
      end
    end

    MemberCoordinatesWorker.perform_async(member_queue)
  end

  MEMBER_FIELDS =
  %w(
    Id
    Name
    FirstName
    LastName
    PPA_City__c
    PPA_State__c
    PPA_Country__c
    toLabel(haa_Race__c)
    Gender__c
    Non_Member_Type__c
    Industry__c
    Organization_Current_Primary_Name__c
    Title_Current_Primary__c
    Title_Induction_Primary__c
    Bio__c
    Military_Service_Military_Branch__c
    Member_Web_Video_Url__c
    Undergraduate_Studies_Institution__c
    PostGraduate_Studies_Institution__c
    Main_Profile_Picture__c
    Profile_Picture__c
    Awards_Year__c
    Member_Web_Quote__c
    haa_Date_of_Death__c
    Member_Class_Year__c
    Primary_Affiliation_Zip_Postal_Code__c
    Active_Military_or_Veteran__c
    Secondary_Graduate_Institution__c
  ).freeze
end
