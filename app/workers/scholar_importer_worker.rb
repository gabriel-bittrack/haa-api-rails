class ScholarImporterWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    @current_user = args[0]
    @scholar_fields = args[1]
    insert_data
    # AttachmentProcessor.new(current_user: @current_user).process
    # ScholarAttachmentWorker.perform_async(@current_user)
    #
    # puts ">>>>>>> process attachments <<<<<<<<<<<<<<"
    # Scholar.find_each do |scholar|
    #   attachments = client.query(scholar_image_attachment(scholar.sf_id))
    #   puts ">>>> attachments: #{attachments.inspec}"
    # end
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
end
