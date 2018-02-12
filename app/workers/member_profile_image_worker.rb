class MemberProfileImageWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  def perform(*args)
    puts ">>>>>>>>>> begin working!!!! <<<<<<<<<<"

    image_url = args[0]
    member_id = args[1]

    member = Member.find_by(id: member_id)
    
    if member
      local_filename = "public/tmp_#{member_id}.png"
      theFile = File.open(local_filename, "wb") do |f|
        f.write HTTParty.get(image_url).body
      end

      begin
        new_file = File.open(local_filename)
        puts ">>>>>>>>> file type : #{File.ftype(local_filename)}"
        member.profile_image = new_file
        new_file.close
        member.save!

      rescue StandardError => error
        puts ">>>> Error trying to save image : #{error.message}"
      ensure
        File.delete(local_filename)
      end

    end
  end
end
