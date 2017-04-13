require_relative 'headcount_helper'

class DistrictRepository

  def initialize
    @districts = []
    @enrollment_repository = EnrollmentRepository.new
  end

  def load_data(args)
    @districts |= build_districts(@enrollment_repository.load_data(args))
    give_districts_data
  end

  def build_districts(districts)
    districts.map { |name| District.new({:name => name.upcase}) }
  end

  def give_districts_data
    @districts.each do |district|
      @enrollment_repository.give_district_data(district)
    end
  end

  def find_by_name(name)
    @districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(fragment)
    @districts.select do |district|
      district.name.include?(fragment.upcase)
    end
  end
end
