require_relative 'headcount_helper'

class DistrictRepository

  def initialize
    @districts = {}
    @repositories = [EnrollmentRepository.new]
  end

  def load_data(args)
    build_districts(@repositories.reduce([]) do |districts, repo|
      districts |= repo.load_data(args)
    end )
    give_districts_data
  end

  def build_districts(districts)
    districts.each { |name| @districts[name.upcase] ||= District.new({:name => name.upcase}) }
  end

  def give_districts_data
    @districts.each do |name, district|
      @repositories.each { |repo| repo.give_district_data(district) }
    end
  end

  def find_by_name(name)
    @districts[name.upcase]
  end

  def find_all_matching(fragment)
    @districts.select do |name, district|
      name.include?(fragment.upcase)
    end.values
  end
end
