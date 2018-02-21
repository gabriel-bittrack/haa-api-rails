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
      end
    else
      "Nothing to process"
    end
  end
