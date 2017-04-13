require_relative 'lib/headcount_helper'

loaded = Load.new("./data/Kindergartners in full-day program.csv")

data = loaded.load_data(:location, :timeframe, :dataformat, :data)

puts data