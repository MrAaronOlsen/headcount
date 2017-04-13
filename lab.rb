require_relative 'lib/headcount_helper'

loaded = Load.new("./data/Kindergartners in full-day program.csv")

data = loaded.make_hash(:location, :timeframe, :dataformat, :data)

puts grouped