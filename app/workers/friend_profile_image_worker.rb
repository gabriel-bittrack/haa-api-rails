class FriendProfileImageWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(*args)
    @image_url = args[0]
    @friend_id = args[1]

    if friend
      begin
        write_file
        write_file_to_s3
      rescue StandardError => error
        puts ">>>> Error tring to save image : #{error.message}"
      ensure
        File.delete(local_filename)
      end
    end
  end

  private
  def write_file_to_s3
    File.open(local_filename) do |file|
      friend.profile_image = file
      friend.save!
    end
  end

  def write_file
    File.open(local_filename, "wb") do |f|
      f.write HTTParty.get(@image_url).body
    end
  end

  def local_filename
    @local_filename ||= "public/tmp_#{@friend_id}.png"
  end
  def friend
    @friend ||= Friend.find_by(id: @friend_id)
  end
end