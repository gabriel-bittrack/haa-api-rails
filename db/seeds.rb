# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Creating users ..."
if Member.find_by(full_name: "Mike O'Dell").nil?
  Member.create({
      full_name: "Mike O'Dell",
      first_name: "Mike",
      last_name: "O'Dell",
      gender: "m",
      city: "Atlanta",
      state: "Georgia",
      country: "USA",
      class_year: "1988",
      industry: "Tech",
      current_org: "Apple, Inc",
      ethnicity: "caucasian",
      short_bio: "This guy is really amazing... no really!!",
      web_url: "https://www.youtube.com/watch?v=gcEPGdJ7pdQ",
      undergraduate_institution: "Georgia Tech",
      profile_photo_url: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fvignette.wikia.nocookie.net%2Fp__%2Fimages%2F5%2F5c%2FSpongebob-squarepants.png%2Frevision%2Flatest%3Fcb%3D20131201153519%26path-prefix%3Dprotagonist&imgrefurl=http%3A%2F%2Fhero.wikia.com%2Fwiki%2FSpongeBob_SquarePants&docid=Mba4azKlWbPjyM&tbnid=ko7s350O0mYwOM%3A&vet=1&w=260&h=390&bih=595&biw=1246&ved=0ahUKEwjf-NLizOnYAhVBeKwKHUSLAvsQxiAIGSgB&iact=c&ictx=1",
      title: "Senior Engineer"
    })
  else
    puts "User Mike O'Dell already exists"
  end

  puts "Create api_users..."
  if (ApiUser.find_by("email": "mike.odell@odellm.com").nil?)
    ApiUser.create(name: "kiosk1", email: "mike.odell@odellm.com", password: "123456")
  else
    puts "ApiUser kiosk1 already exists"
  end
