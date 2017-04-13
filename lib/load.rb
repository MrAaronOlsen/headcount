require_relative 'headcount_helper'

class Load
  def initialize(file)
    @file = file
  end

  def load_data(*args)
    data = [[], []]

    CSV.foreach(@file, headers: true, header_converters: :symbol ) do |row|
      data[0] << args.map { |arg| [arg, row[arg]] }.to_h
      data[1] << row[:location].upcase
    end

    data
  end

end