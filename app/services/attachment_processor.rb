class AttachmentProcessor < SyncProcessor
  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    puts ">>>>>>> process attachments <<<<<<<<<<<<<<"
    Scholar.find_each do |scholar|
      puts ">>>> trying to find scholars!"
      attachments = client.query(scholar_image_attachment(scholar.sf_id))
      puts ">>>> attachments: #{attachments.inspec}"
    end
  end

  private
  def scholar_image_attachment(id)
    "select id from attachment where parentId='#{id}'"
  end
end