require_relative 'lib/headcount_helper'
require_relative 'lib/enums'

class EconomicProfileRepositoryBeta
  def initialize
    @data_sets = {}
    @economic_profiles = []
  end

  def load_data(args)
    return nil if args[:economic_profile].nil?

    args[:economic_profile].each do |data_set, address|
      loader = Load.new(address).load_data( :location,
                                            :poverty_level,
                                            :timeframe,
                                            :dataformat,
                                            :data )

      @data_sets[data_set] = loader_cleaner(loader)
    end
    build_economic_profiles
  end

  def build_economic_profiles
    pre_profiles= {}
    names = collect_names
    names.each do |name|
      pre_profiles[name]= {}
    end

    #give the econ profile a name
    economic_profile.each do |study|
    	pre_profiles.each do |name|
        if pre_profiles[name][study].nil?
          pre_profiles[name][study] => {}
        end
      end
    end

    # add median income data
    economic_profile[:median_household_income].each do |line|
      pre_profiles.each do |name|
        if line[:location] == name
          name[:median_household_income] => {line[:timeframe] => line[:data]}
        end
      end
    end

    # add children
    economic_profile[:children_in_poverty].each do |line|
      pre_profiles.each do |name|
        if line[:location] == name
          name[:children_in_poverty] => {line[:timeframe] => line[:data]}
        end
      end
    end

    # add lunch
    economic_profile[:free_or_reduced_price_lunch].each do |line|
      pre_profiles.each do |name|
        if line[:location] == name
          name[:free_or_reduced_price_lunch] => { eeach if line[:timeframe] => {line[:data]}}
        end
      end
    end






  end

  def collect_names
    @data_sets.reduce([]) do |all_names, data_set|
      all_names |= data_set[1].map { |line| line[:location] }
    end
  end
end
