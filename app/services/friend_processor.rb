require 'nokogiri'

class FriendProcessor < SyncProcessor
  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    delete
    process_friends(client.query(friend_sql_statement))
  end

  private
  def extract_profile_image(tag_fragment)
    document = Nokogiri::XML::DocumentFragment.parse(tag_fragment)
    node = document.at_css('img')
    node['src']
  end

  def friend_sql_statement
    @sql_statement ||= "select " + FRIEND_FIELDS.join(",") + " from Contact where RecordType.Name in ('Non-Member')"
  end

  def delete
    Friend.delete_all
  end

  def process_friends(friends)
    friends.each do |friend|
      image_url = extract_profile_image(friend.Main_Profile_Picture__c) if friend.Main_Profile_Picture__c

      friend = Friend.create(
        full_name: friend.Name,
        first_name: friend.FirstName,
        last_name: friend.LastName,
        city: friend.PPA_City__c,
        state: friend.PPA_State__c,
        country: friend.PPA_Country__c,
        current_org: friend.Current_Organization__c,
        title: friend.Title,
        zipcode: friend.Primary_Affiliation_Zip_Postal_Code__c
      )

      if (image_url)
        FriendProfileImageWorker.perform_async(image_url, friend.id)
      end
    end
  end

  FRIEND_FIELDS =
  %w(
    Id
    Name
    FirstName
    LastName
    PPA_City__c
    PPA_State__c
    PPA_Country__c
    Title
    Current_Organization__c
    Main_Profile_Picture__c
    Primary_Affiliation_Zip_Postal_Code__c
  )
end
