class ScholarProfileImageWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    puts ">>>>>> Scholar profile image processor !!!!!"
    @scholar_id = args[0]
    @body = args[1]

    if scholar
      begin
        write_file
        write_file_to_s3
      rescue StandardError => error
        puts ">>>> Error trying to save image : #{error.message}"
      ensure
        File.delete(local_filename)
      end
    end
  end

  private

  def write_file_to_s3
    File.open(local_filename) do |file|
      scholar.profile_image = file
      scholar.save!
    end
  end

  def write_file
    File.open(local_filename, "wb") do |f|
      f.write @body
    end
  end

  def local_filename
    @local_filename ||= "public/tmp_#{@scholar_id}.png"
  end

  def scholar
    @scholar ||= Scholar.find_by(id: @scholar_id)
  end
end
