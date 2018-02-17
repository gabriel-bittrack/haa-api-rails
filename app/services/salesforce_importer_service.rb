require "open-uri"
require "net/http"

class SalesforceImporterService
  require 'nokogiri'

  def initialize(current_user:)
    @current_user = current_user
  end

  def perform(type:)
    case type
    when "members"
      MemberProcessor.new(current_user: @current_user).process
    when "scholars"
      ScholarProcessor.new(current_user: @current_user).process
      # Scholar.find_each do |scholar|
      #   attachments = @client.query(scholar_image_attachment(scholar.sf_id))
      #   puts ">>>> attachments: #{attachments}"
      end
    else
      "Nothing to process"
    end
  end
