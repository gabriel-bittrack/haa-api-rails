class AttachmentProcessor < SyncProcessor
  def initialize(current_user:)
    @current_user = current_user
  end

  def process_attachments

  end

  private
  def scholar_image_attachment(id)
    "select id from attachment where parentId='#{id}'"
  end
end