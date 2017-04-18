require_relative 'headcount_helper'

class EconomicProfileRepository

  def initialize
    @data_sets = {}
    @economic_profiles = []
  end

  def load_data(args)
    return nil if args[:economic_profile].nil?

    args[:economic_profile].each do |data_set, address|
      loader = Load.new(address).load_data( :location, :poverty_level, :timeframe,
                                            :dataformat, :data )
      @data_sets[data_set] = loader_cleaner(loader)
    end
    build_economic_profiles
  end

  def build_economic_profiles
    names = collect_names

    names.each do |name|
      economic_profile = {}
      economic_profile[:name] = name.upcase

      @data_sets.each do |data_name, data_set|
        economic_profile[data_name] = collect_data(name, data_set)
      end
      @economic_profiles << EconomicProfile.new(economic_profile)
    end
    @data_sets
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

  def loader_cleaner(loader)
    loader.map do |test|
      test.delete_if { |k, v| v.nil? }
    end
  end

  def find_by_name(name)
    @economic_profiles.find { |economic_profile| economic_profile.name == name }
  end


end
