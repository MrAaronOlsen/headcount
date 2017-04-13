require_relative 'headcount_helper'

class EnrollmentRepository

  def initialize
    @enrollments = {}
  end

  def load_data(args)
    enrollments = args[:enrollment]
    enrollments.each do |data_set, address|
      @enrollments[data_set] = Load.new(address).make_hash
    end
  end

  def find_by_name(name)
     # return nill if no name match or check against district list
    Enrollment.new({:name => name,
                      :kindergarten_participation => collect_kindergarten_data(name)
                      # :highschool =>  finds_highschool(name)
                    })
  end

  def collect_kindergarten_data(name)
    temp = {}
    @enrollments[:kindergarten].each do |line|
      temp[line[:timeframe].to_i] = line[:data].to_f if line[:location] == name
    end
    temp
  end

  def give_district_data(district)
    district.enrollment = find_by_name(district.name)
  end

end