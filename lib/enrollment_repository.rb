require_relative 'headcount_helper'

class EnrollmentRepository

  def initialize
    @enrollments = {}
  end

  def load_data(args)
    enrollments = args[:enrollment]
    enrollments.each do |name, address|
      @enrollments[name] = Load.new(address).parsable_file

    end
  end

end
