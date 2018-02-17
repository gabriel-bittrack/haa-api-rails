class ScholarImageProcessorWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    puts ">>>>>> incoming args: #{args.inspect}s"
    @client = args[0]
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>> performing scholar importer <<<<<<<<<<<<<<<<<"
    Scholar.find_each do |scholar|
      puts ">>>> found scholar : #{scholar.sf_id}"
      attachments = @client.query(scholar_image_attachment(scholar.sf_id))
      # if attachments
      #   attachments.each do |att|
      #     # puts "what are the attachments : #{att}"
      #     puts "Found attachments"
      #   end
      # end
    end
  end

  private
  def scholar_image_attachment(id)
    "select id from attachment where parentId='#{id}'"
  end

  # def client
  #   @client ||= Restforce.new :oauth_token => @current_user.oauth_token,
  #     :refresh_token => @current_user.refresh_token,
  #     :instance_url => @current_user.instance_url,
  #     :client_id => ENV['SALESFORCE_APP_ID'],
  #     :client_secret => ENV['SALESFORCE_APP_SECRET']
  # end
end
