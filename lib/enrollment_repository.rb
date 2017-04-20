require_relative 'headcount_helper'

class EnrollmentRepository
  def initialize
    @data_sets = {}
    @enrollments = []
  end

  def load_data(args)
    return nil if args[:enrollment].nil?

    args[:enrollment].each do |data_set, address|
      loader = Load.new(address).load_data( :location,
                                            :timeframe,
                                            :dataformat,
                                            :data )


      @data_sets[data_set] = loader
    end
    build_enrollments
  end

  def build_enrollments
    names = collect_names

    names.each do |name|
      enrollment = {}
      enrollment[:name] = name.upcase

      @data_sets.each do |data_name, data_set|
        enrollment[data_name] = collect_data(name, data_set)
      end
      @enrollments << Enrollment.new(enrollment)
    end

  end

  def collect_names
    @data_sets.reduce([]) do |all_names, data_set|
      all_names |= data_set[1].map { |line| line[:location] }
    end
  end

  def collect_data(name, data_set)
    temp = {}
    data_set.each do |line|
      temp[line[:timeframe].to_i] = line[:data].to_f if line[:location] == name
    end
    temp
  end

  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name == name }
  end
end
