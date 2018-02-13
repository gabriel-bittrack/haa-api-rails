class MemberProfileImageWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    @image_url = args[0]
    @member_id = args[1]
    
    if member
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
      member.profile_image = file
      member.save!
    end
  end

  def write_file
    File.open(local_filename, "wb") do |f|
      f.write HTTParty.get(@image_url).body
    end
  end

  def local_filename
    @local_filename ||= "public/tmp_#{@member_id}.png"
  end

  def member
    @member ||= Member.find_by(id: @member_id)
  end
end
