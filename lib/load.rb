require_relative 'headcount_helper'

class Load
  def initialize(file)
    @file = file
  end

  def make_hash(*args)
    data = []
    districts = []

    CSV.foreach(@file, headers: true, header_converters: :symbol ) do |row|
      data << args.map { |arg| [arg, row[arg]] }.to_h
      districts << row[:location]
    end
    
    data << districts
  end

end
