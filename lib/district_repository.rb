require_relative 'headcount_helper'

class DistrictRepository

  def initialize
    @districts = []
    @enrollment_repository = EnrollmentRepository.new
  end

  def load_data(args)
    #v method that junk v
    csv = Load.new(args[args.keys[0]][args[args.keys[0]].keys[0]]).parsable_file
    build_districts(csv)
    @enrollment_repository.load_data(args)
    # @repositories.each { |repository| repository.load_data(args) }
    give_districts_data
  end

  def build_districts(csv)
    names = csv.each.map { |line| line[:location] }
    names.uniq.each { |name| @districts << District.new({:name => name.upcase}) }
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
