require_relative 'headcount_helper'

class DistrictRepository

  def initialize
    @districts = []
    @repositories = [EnrollmentRepository.new] #,statwide.new, #econ.new
  end

  def load_data(args)
    @repositories.each { |repository| repository.load_data(args) }
    build_district_list
    build_districts(@districts)

    give_districts_data
  end

  def list_of_unique_district_names(args)
    @repositories.reduce([]) do |districts, repository|
      districts |= repository.load_data(args)
    end
  end

  def build_districts(district_names)
    district_names.each do |name|
      @districts << District.new({:name => name.upcase})
    end
  end

  def give_districts_data
    @districts.each do |name, district|
      @repositories.each { |repo| repo.give_district_data(district) }
    end
  end

  def find_by_name(name)
    @districts.find { |district| district == name }
  end

  def find_all_matching(fragment)
    @districts.select do |district|
      district.name.include?(fragment.upcase)
    end
  end
end
