require_relative 'headcount_helper'

class EnrollmentRepository

  def initialize
    @enrollments = {}
  end

  def load_data(args)
    enrollments = args[:enrollment]
    enrollments.each do |data_set, address|
      @enrollments[data_set] = Load.new(address).parsable_file
    end
  end

  def find_by_name(name)
    # nil if name does not exist
    Enrollment.new({:name => name,
                        :kindergarten_participation => collect_kindergarten_data(name)
                        # :highschool => finds_highschool(name)
                      })
  end

  def collect_kindergarten_data(name)
    temp_data = {}
    @enrollments[:kindergarten].each do |line|
      temp_data[line[:timeframe].to_i] = line[:data].to_f if line[:location] == name
    end
    temp_data
  end


end
