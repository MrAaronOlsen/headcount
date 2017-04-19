require_relative 'headcount_helper'

class EconomicProfile
  attr_reader :data
  def initialize(data)
    @data = data
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
    
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
  end

  def free_or_reduced_price_lunch_number_in_year(year)
  end

  def title_i_in_year(year)
  end

end
