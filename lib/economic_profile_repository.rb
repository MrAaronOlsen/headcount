require_relative 'headcount_helper'

class EconomicProfileRepository
  def initialize
    @data_sets = {}
    @economic_profiles = []
  end

  def load_data(args)
    return nil if args[:economic_profile].nil?

    args[:economic_profile].each do |data_set, address|
      loader = Load.new(address).load_data( :location, :poverty_level,
                                            :timeframe, :dataformat, :data )
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
        economic_profile[data_name] = direct_data(data_name, data_set, name)
      end
      @economic_profiles << EconomicProfile.new(economic_profile)
    end
    @data_sets
  end

  def direct_data(data_name, data_set, name)
    case data_name
    when :median_household_income
      collect_median_household_income(data_name, data_set, name)
    when :children_in_poverty
      collect_children_in_poverty(data_name, data_set, name)
    when :free_or_reduced_price_lunch
      collect_free_and_reduced_price_lunch(data_name, data_set, name)
    when :title_i
      collect_children_in_poverty(data_name, data_set, name)
    end
  end

  def collect_median_household_income(data_name, data_set, name)
    by_name = data_set.select { |line| line[:location] == name }
    by_name.hash_map do |line|
        {time_range(line[:timeframe]) => line[:data].to_i}
    end
  end

  def collect_children_in_poverty(data_name, data_set, name)
    by_name = data_set.select { |line| line[:location] == name }
    data_set.hash_map do |line|
        {line[:timeframe].to_i => line[:data].to_f}
    end
  end

  def collect_free_and_reduced_price_lunch(data_name, data_set, name)
    by_name = data_set.select { |line| line[:location] == name }
    by_poverty = by_name.select do |line|
      line[:poverty_level] == "Eligible for Free or Reduced Lunch"
    end
    percent = by_poverty.select { |line| line[:dataformat] == 'Percent' }
    number = by_poverty.select { |line| line[:dataformat] == 'Number' }

    percents = percent.hash_map do |line|
      {line[:timeframe].to_i => { percentage: line[:data].to_f } }
    end

    numbers = number.hash_map do |line|
      {line[:timeframe].to_i => { total: line[:data].to_f } }
    end
    numbers.merge(percents) { |date, d1, d2| d1.update(d2) }
  end

  def time_range(range)
    range.split('-').map { |date| date.to_i }
  end

  def collect_names
    @data_sets.reduce([]) do |all_names, data_set|
      all_names |= data_set[1].map { |line| line[:location] }
    end
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
