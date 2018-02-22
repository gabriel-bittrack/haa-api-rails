class ScholarAttachmentWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    current_user = args[0]
    AttachmentProcessor.new(current_user: current_user).process
  end
end
