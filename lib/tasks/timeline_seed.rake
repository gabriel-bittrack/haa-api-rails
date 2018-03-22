require 'time_line_seed'

namespace :timeline_seed do
  desc "Reset timeline data for site"
  task :reset => :environment do
    puts ">>>> about to call seed!"
    TimeLineSeed.seed
    puts ">>>> completed calling seed!!"
  end
end
