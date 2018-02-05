class SalesforceImporterService
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
      process_scholars
    else
      "Nothing to process"
    end
  end

  private

  def process_scholars
    puts "Not implemented"
  end

  def process_members(members)
    members.each do |account|
      Member.create(
        full_name: account.Name,
        first_name: account.FirstName,
        last_name: account.last_name,
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
      )
    end
  end

  def delete_all_members
    Member.delete_all

  end
  def client
    @client ||= Restforce.new :oauth_token => @current_user.oauth_token,
      :refresh_token => @current_user.refresh_token,
      :instance_url => @current_user.instance_url,
      :client_id => ENV['SALESFORCE_APP_ID'],
      :client_secret => ENV['SALESFORCE_APP_SECRET']
  end

  def member_sql_statement
    @sql_statement ||= "select " + MEMBER_FIELDS.join(",") + " from Contact where RecordType.Name IN ('Member')"
  end

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
    ).freeze
end
