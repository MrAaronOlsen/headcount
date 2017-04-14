require_relative 'headcount_helper'

class DistrictRepository

  def initialize
    @districts = []
    @repositories = [EnrollmentRepository.new] #,statwide.new, #econ.new
  end

  def load_data(args)
    @repositories.each { |repository| repository.load_data(args) }

    build_districts(collect_names)
    give_districts_data
  end

  def find_by_name(name)
    @districts.find { |district| district.name == name }
  end

  def find_all_matching(fragment)
    @districts.select do |district|
      district.name.include?(fragment.upcase)
    end
  end

  def collect_names
    @repositories.reduce([]) do |all_names, repository|
      all_names |= repository.collect_names
    end
  end

  def build_districts(district_names)
    district_names.each do |name|
      @districts << District.new({:name => name.upcase})
    end
  end

  def give_districts_data
    @districts.each do |district|
      @repositories.each do |repo|
        district.repositories << repo.find_by_name(district.name)
      end
    end
  end
  
end
