require_relative 'lib/headcount_helper'

loaded = Load.new("./data/Kindergartners in full-day program.csv")

data = loaded.make_hash(:timeframe, :data)

# data.each { |line| print line; puts "" }

grouped = data.group_by {|line| line[0].to_sym}

puts grouped



[{:location => "Colorado", :timeframe => '3004', :data => '0.345'}, {:location => "Colorado", :timeframe => '3005', :data => '0.164'}]