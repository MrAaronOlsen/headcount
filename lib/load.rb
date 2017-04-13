require_relative 'headcount_helper'

class Load
  def initialize(file)
    @file = file
  end

  def load_data(*args)
    data = []

    CSV.foreach(@file, headers: true, header_converters: :symbol ) do |row|
      data << args.map { |arg| [arg, row[arg]] }.to_h
    end

    data
  end

end