require_relative 'headcount_helper'

class EconomicProfile
  attr_reader :data
  def initialize(data)
    @data = data
    binding.pry
  end

  def name
    @data[:name]
  end

  def median_household_income_in_year(year)
    income_years = []
    data[:median_houshold_income].each do |line|
      year_range = string_to_range(line[:timeframe])
      income_years << line[:data] if year_range.include?(year)
    end
    income_integers = income_years.map { |yr| yr.to_i}
    income_integers.inject(:+) / income_years.count
  end

  def string_to_range(string_years)
    range = (string_years[0..3]..string_years[5..8]).to_a
    range.map{|yr| yr.to_i}
  end

  def median_household_income_average
    incomes = []
    @data[:median_houshold_income].each do |line|
       incomes << line[:data].to_i
     end
   incomes.inject(:+) / incomes.count
  end

  def children_in_poverty_in_year(year)
    desired = []
    @data[:children_in_poverty].each do |line|
      if line[:timeframe] == "#{year}" && line[:dataformat] == "Percent"
        desired << line[:data]
      end
    end
    desired[0].to_f
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    desired = []
    @data[:free_or_reduced_price_lunch].each do |line|
      if right_year?(line, year) && percent?(line) && free_or_reduced?(line)
        desired << line[:data]
      end
    end
    desired[0].to_f
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    desired = []
    @data[:free_or_reduced_price_lunch].each do |line|
      if right_year?(line, year) && number?(line) && free_or_reduced?(line)
        desired << line[:data]
      end
    end
    raise UnknownDataError.new('unknown year') if desired[0].nil?
    desired[0].to_f
  end

  def right_year?(line, year)
    line[:timeframe] == "#{year}"
  end

  def number?(line)
    line[:dataformat] == "Number"
  end

  def percent?(line)
    line[:dataformat] == "Percent"
  end

  def free_or_reduced?(line)
    line[:poverty_level] == "Eligible for Free or Reduced Lunch"
  end

  def title_i_in_year(year)
    desired = []
    @data[:title_i].each do |line|
      if line[:timeframe] == "#{year}"
        desired << line[:data]
      end
    end
    raise UnknownDataError.new('unknown year') if desired[0].nil?
    desired[0].to_f
  end

end
