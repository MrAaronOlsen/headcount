require_relative 'headcount_helper'

class Load
  def initialize(file)
    @file = file
    @districts = []
  end

  def parsable_file
    CSV.foreach @file, headers: true, header_converters: :symbol
  end

  def make_hash
    data = []

    CSV.foreach(@file, headers: true, header_converters: :symbol ) do |row|
      data << {:location => row[:location], :timeframe => row[:timeframe],
               :dataformat => row[:dataformat], :data =>row[:data] }

      @districts << row[:location]
    end

    data
  end

end
