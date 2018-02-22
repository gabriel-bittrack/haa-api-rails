class ScholarImporterWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    puts "importing scholars!!!!!!"
    @current_user = args[0]
    @scholar_fields = args[1]

    puts ">>>>>>> What is current_user : #{@current_user}"
    insert_data
    # AttachmentProcessor.new(current_user: @current_user).process
    # ScholarAttachmentWorker.perform_async(@current_user)
    #
    puts ">>>>>>> process attachments <<<<<<<<<<<<<<"
    Scholar.find_each do |scholar|
      attachments = client.query(scholar_image_attachment(scholar.sf_id))
      puts ">>>> Should have a collection of attachments : #{attachments.size}"
      attachments.each do |att|
        puts "Attachment : #{att}"
      end
    end
  end

  private

  def scholar_image_attachment(id)
    "select id from attachment where parentId='#{id}'"
  end

  def insert_data
    Scholar.bulk_insert do |worker|
      if @scholar_fields.present?
        @scholar_fields.each do |attrs|
          worker.add(attrs)
        end
      end
    end
  end

  def client
    @client ||= Restforce.new :oauth_token => @current_user["oauth_token"],
      :refresh_token => @current_user["refresh_token"],
      :instance_url => @current_user["instance_url"],
      :client_id => ENV['SALESFORCE_APP_ID'],
      :client_secret => ENV['SALESFORCE_APP_SECRET']
  end
end
