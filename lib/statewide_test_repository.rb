require_relative 'headcount_helper'

class StatewideTestRepository

  def initialize
    @data_sets = {}
    @statewide_tests = []
  end

  def load_data(args)

    args[:statewide_testing].each do |data_set, address|
      loader = Load.new(address).load_data( :location, :score, :race_ethnicity, :timeframe,
                                            :dataformat, :data )
      @data_sets[data_set] = loader_cleaner(loader)
    end
    build_statewide_tests
  end

  def build_statewide_tests
    names = collect_names

    names.each do |name|
      statewide_test = {}
      statewide_test[:name] = name.upcase

      @data_sets.each do |data_name, data_set|
        statewide_test[data_name] = collect_data(name, data_set)
      end
      @statewide_tests << StatewideTest.new(statewide_test)
    end
    @data_sets
  end

  def find_by_name(name)
    @statewide_tests.find { |statewide_test| statewide_test.name == name }
  end

  def loader_cleaner(loader)
    loader.map do |test|
      test.delete_if { |k, v| v.nil? }
    end
  end

  def collect_names
    @data_sets.reduce([]) do |all_names, data_set|
      all_names |= data_set[1].map { |line| line[:location] }
    end
  end

  def collect_data(name, data_set)
    temp = []
    data_set.each do |line|
        temp << line if line[:location] == name
    end
    temp
  end

end
