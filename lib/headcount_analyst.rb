require_relative 'headcount_helper'

class HeadcountAnalyst
  attr_reader :district_repository
  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(location, compare)
    compare[:location_1] = @district_repository.find_by_name(location)
    compare[:location_2] = @district_repository.find_by_name(compare[:against])

    average(compare[:location_1].enrollment.kindergarten_participation_by_year.values) /
    average(compare[:location_2].enrollment.kindergarten_participation_by_year.values)
  end

  def kindergarten_participation_rate_variation_trend(location, compare)
    compare[:location_1] = @district_repository.find_by_name(location)
    compare[:location_2] = @district_repository.find_by_name(compare[:against])

    trend = []
    trend << compare[:location_1].enrollment.kindergarten_participation_by_year.to_
    trend << compare[:location_2].enrollment.kindergarten_participation_by_year.to_a
      ## look at the data that this is producing to work with ^^^^^
    binding.pry
    trends = trend.group_by { |year| year[0] }

  end


  def kindergarten_participation_against_high_school_graduation(district)

  end


  def average(data)
    data.reduce(0) { |sum, data| sum + data } / data.length
  end


end
