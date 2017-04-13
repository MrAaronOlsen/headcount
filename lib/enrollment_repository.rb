require_relative 'headcount_helper'

class EnrollmentRepository

  def initialize
    @enrollments = {}
  end

  def load_data(args)
    districts = []
    args[:enrollment].each do |data_set, address|
      loader = Load.new(address).load_data(:location, :timeframe,
                                           :dataformat, :data)
      districts |= loader[1]
      @enrollments[data_set] = loader[0]
    end
    districts
  end

  def find_by_name(name)
    Enrollment.new({:name => name,
                    :kindergarten_participation =>
                      collect_data( :name => name,
                                    :data_set => :kindergarten,
                                    :column1 => :timeframe,
                                    :column2 => :data ),
                    :high_school_graduation =>
                      collect_data( :name => name,
                                    :data_set => :high_school_graduation,
                                    :column1 => :timeframe,
                                    :column2 => :data )
                  })
  end

  def collect_data(args)
    temp = {}
    binding.pry
    @enrollments[args[:data_set]].each do |line|
      temp[line[args[:column1]].to_i] = line[args[:column2]].to_f if line[:location] == args[:name]
    end
    temp
  end

  def give_district_data(district)
    district.enrollment = find_by_name(district.name)
  end

end