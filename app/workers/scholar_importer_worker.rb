class ScholarImporterWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    puts ">>>>> made it to worker"
    @scholar_fields = args[0]
    insert_data
  end

  private

  def insert_data
    puts ">>>>>> Inserting data!"
    Scholar.bulk_insert do |worker|
      @scholar_fields.each do |attrs|
        worker.add(attrs)
      end
    end
  end
end
