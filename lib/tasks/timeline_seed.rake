require 'time_line_seed'

namespace :timeline_seed do
  desc "Reset timeline data for site"
  task :reset => :environment do
    TimeLineSeed.seed
  end
end
