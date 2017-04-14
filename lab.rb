require_relative 'lib/headcount_helper'
#
# loaded = Load.new("./data/Kindergartners in full-day program.csv")
#
# data = loaded.load_data(:location, :timeframe, :dataformat, :data)
#
# puts data

def match_data(first, second)
    [ first.select { |key| second.include?(key) },
    second.select { |key| first.include?(key) } ]
end

hash1 = {2010 => 2.0, 2011 => 3.0, 2012 => 4.0, 2013 => 5.0}
hash2 = {2010 => 1.0, 2011 => 1.5, 2012 => 2.0, 2015 => 3.5, 2013 => 2.5 }

to_merge = match_data(hash1, hash2)

binding.pry

merged = to_merge[0].merge(to_merge[1]) { |date, data1, data2| data1 / data2 }

puts merged