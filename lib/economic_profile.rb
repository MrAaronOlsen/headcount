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

    @data[:median_household_income].each do |line|
      year_range = dates_to_range(line[0])
      income_years << line[1] if year_range.include?(year)
    end
    income_years.inject(:+) / income_years.count
  end

  def dates_to_range(dates)
    ranged = (dates[0]..dates[1]).to_a
  end

  def median_household_income_average
    incomes = []
    @data[:median_household_income].each do |line|
       incomes << line[1]
     end
   incomes.inject(:+) / incomes.count
  end

  def children_in_poverty_in_year(year)
    @data[:children_in_poverty].each do |line|
      return line[1] if line[0] == year
    end
    raise UnknownDataError.new('unknown year')
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    @data[:free_or_reduced_price_lunch].each do |line|
      return line[1][:percentage] if line[0] == year
    end
    raise UnknownDataError.new('unknown year')
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    @data[:free_or_reduced_price_lunch].each do |line|
      return line[1][:total] if line[0] == year
    end
    raise UnknownDataError.new('unknown year')
  end

  def title_i_in_year(year)
    @data[:title_i].each do |line|
      return line[1] if line[0] == year
    end
    raise UnknownDataError.new('unknown year')
  end

end
