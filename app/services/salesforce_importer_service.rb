class SalesforceImporterService
  def initialize(current_user:)
    @current_user = current_user
  end

  def perform(type:)
    case type
    when "members"
      MemberProcessor.new(current_user: @current_user).process
    when "scholars"
      ScholarProcessor.new(current_user: @current_user).process
    when "attachments"
      AttachmentProcessor.new(current_user: @current_user).process
    when "friends"
      FriendProcessor.new(current_user: @current_user).process
    when "colleges"
      CollegiatePartnerProcessor.new(current_user: @current_user).process
    when "scholar_geocode"
      puts ">>>> process scholars geocode!"
      GeocodeScholarProcessor.new(current_user: @current_user).process
    when "scholar_scholarships"
      puts ">>>> process scholar scholar scholarships"
      ScholarScholarshipProcessor.new(current_user: @current_user).process
    else
      "Nothing to process"
    end
  end
end
