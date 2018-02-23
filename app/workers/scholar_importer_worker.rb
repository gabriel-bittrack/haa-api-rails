class ScholarImporterWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0, queue: 'critical'

  def perform(*args)
    @current_user = args[0]
    @scholar_fields = args[1]
    insert_data
  end

  private
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
