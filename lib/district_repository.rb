require_relative 'headcount_helper'

class DistrictRepository

  def initialize
    @districts = {}
    @repositories = [EnrollmentRepository.new]
  end

  def load_data(args)
    build_districts(list_of_unique_district_names(args))
    give_districts_data
  end

  def list_of_unique_district_names(args)
    @repositories.reduce([]) do |districts, repository|
      districts |= repository.load_data(args)
    end
  end

  def build_districts(district_names)
    district_names.each { |name| @districts[name.upcase] ||= District.new({:name => name.upcase}) }
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
    matching = @districts.select do |name, district|
      name.include?(fragment.upcase)
    end
    matching.values
  end
end
