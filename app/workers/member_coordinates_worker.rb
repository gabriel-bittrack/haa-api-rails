require 'mapbox-sdk'

Mapbox.access_token = ENV.fetch("MAPBOX_TOKEN")

class MemberCoordinatesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 0

  def perform(*args)
    member_ids = args[0]

    remaining_count = member_ids.length
    job_counter = 0
    member_ids.each do |member_id|
      job_counter += 1
      remaining_count -= 1

      puts ">>> processing current_count : #{job_counter} remaining: #{remaining_count}"
      puts "************* member id: #{member_id} ***********************"
      member = Member.find_by(id: member_id)

        begin
          places = geocode_member(member)
          coords = places[0].fetch('features')[0].fetch('geometry').fetch('coordinates')
          puts ">>>> processing coords : #{coords}"

          member.lng = coords[0]
          member.lat = coords[1]
          member.save!
        rescue Exception => e
          puts ">>>> handled exception: #{e.message}"
        end


      if job_counter === 598 || remaining_count === 0
        job_counter = 0
        sleep(61) unless remaining_count === 0
      end
    end
  end

  private
  def geocode_member(member)
    places = ''
    if (member.zipcode)
      puts ">>>>> geocoding using zipcode: #{member.zipcode}"
      places = Mapbox::Geocoder.geocode_forward("#{member.zipcode}")
    else
      puts ">>>>> geocoding using city, state: #{member.city}, #{member.state}"
      places = Mapbox::Geocoder.geocode_forward("#{member.city}, #{member.state}")
    end

    places
  end
end
