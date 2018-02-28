class AttachmentProcessor < SyncProcessor

  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    puts ">>>>>> Going to process attachments now!"
    current_user_hash = { oauth_token: @current_user.oauth_token, refresh_token: @current_user.refresh_token, instance_url: @current_user.instance_url }
    ScholarAttachmentWorker.perform_async(current_user_hash)
  end
end
