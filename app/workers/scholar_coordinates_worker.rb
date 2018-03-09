require 'mapbox-sdk'

Mapbox.access_token = ENV.fetch("MAPBOX_TOKEN")

class ScholarCoordinatesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 0

  def perform(*args)
    puts ">>>>> begin processing"
    scholar_ids = args[0]

    remaining_count = scholar_ids.length
    job_counter = 0
    scholar_ids.each do |scholar_id|
      job_counter += 1
      remaining_count -= 1

      puts ">>> processing current_count : #{job_counter} remaining: #{remaining_count}"
      puts "************* scholar id: #{scholar_id} ***********************"
      scholar = Scholar.find_by(id: scholar_id)
      if (scholar.city || scholar.state)
        begin
          places = Mapbox::Geocoder.geocode_forward("#{scholar.city}, #{scholar.state}")
          coords = places[0].fetch('features')[0].fetch('geometry').fetch('coordinates')
          puts ">>>> processing coords : #{coords}"

          scholar.lng = coords[0]
          scholar.lat = coords[1]
          scholar.save!
        rescue Exception => e
          puts ">>>> handled exception: #{e.message}"
        end
      end
    
      if job_counter === 598 || remaining_count === 0
        job_counter = 0
        sleep(61) unless remaining_count === 0
      end
    end
  end
end