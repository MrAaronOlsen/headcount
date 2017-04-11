require_relative 'headcount_helper'

class Load
  def initialize(file)
    @file = file
  end

  def parsable_file
    CSV.open @file, headers: true, header_converters: :symbol
  end
end
