require 'nokogiri'

class MemberProcessor < SyncProcessor
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
    @sql_statement ||= "select " + MEMBER_FIELDS.join(",") + " from Contact where RecordType.Name IN ('Member', 'New Member') AND Association_Member__c = true"
  end

  def delete
    Member.delete_all
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
        bio: account.Bio__c,
        award_date: account.Awards_Year__c,
        web_url: account.Member_Web_Video_Url__c,
        undergraduate_institution: account.Undergraduate_Studies_Institution__c,
        graduate_institution: account.PostGraduate_Studies_Institution__c,
        profile_photo_url: image_url,
        quote: account.Member_Web_Quote__c,
        date_of_death: account.haa_Date_of_Death__c,
        ethnicity: account.haa_Race__c
      )

      if (image_url)
        MemberProfileImageWorker.perform_async(image_url, member.id)
      end
    end
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
    Current_Organization__c
    Title
    Bio_Short__c
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
  ).freeze
end