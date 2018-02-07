

class MemberProfileImageWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    puts ">>>>> ARGS : #{args.inspect}"
    image_url = args[0]
    member_id = args[1]

    puts ">>>>>> what is image_url: #{image_url["image_url"]}"
    response = HTTParty.get(image_url)
  end
end
