class ScholarAttachmentWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0, queue: 'default'

  def perform(*args)
    puts ">>>> processing scholar attachments <<<<<"
    @current_user_hash = args[0]

    Scholar.find_each do |scholar|
      puts "Scholar : #{scholar.full_name}"
      attachments = client.query(scholar_image_attachment(scholar.sf_id))
      attachments.each do |att|
        puts "Name : #{att.Name}"
        puts "ContentType : #{att.ContentType}"

        if att.ContentType == "image/jpeg" || att.ContentType == "image/jpg" || att.ContentType == "image/png" || att.ContentType == "image/gif"
          puts ">>>>> processing the image and uploading to S3"
          begin
            puts ">>>> Starting to write the files"
            write_file(scholar, att)
            write_file_to_s3(scholar)
          rescue StandardError => error
            puts ">>>> Error trying to save image : #{error.message}"
          ensure
            # File.delete(local_filename(scholar.id))
          end
          puts ">>>>> Completed processing, I hope"
        end
      end
    end
  end

  private

  def write_file_to_s3(scholar)
    puts "Writing s3 file for scholar: #{scholar.id}"
    File.open(local_filename(scholar.id)) do |file|
      scholar.profile_image = file
      scholar.save!
    end
  end

  def write_file(scholar, att)
    puts "Writing file for processing: #{scholar.id}"
    File.open(local_filename(scholar.id), "wb") do |f|
      f.write att.Body
    end
  end

  def local_filename(scholar_id)
    @local_filename ||= "public/tmp_#{scholar_id}.png"
  end

  def scholar_image_attachment(id)
    "select Id, ContentType, Body, Description, IsPrivate, Name, OwnerId from attachment where parentId='#{id}'"
  end

  def client
    @client ||= Restforce.new :oauth_token => @current_user_hash["oauth_token"],
      :refresh_token => @current_user_hash["refresh_token"],
      :instance_url => @current_user_hash["instance_url"],
      :client_id => ENV['SALESFORCE_APP_ID'],
      :client_secret => ENV['SALESFORCE_APP_SECRET']
  end
end
