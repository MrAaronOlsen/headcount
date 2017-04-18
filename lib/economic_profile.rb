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
  end

  def median_household_income_average
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
