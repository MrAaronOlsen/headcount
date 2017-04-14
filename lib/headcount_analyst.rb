require_relative 'headcount_helper'

class HeadcountAnalyst
  attr_reader :repo

  def initialize(district_repository)
    @repo = district_repository
  end

  def kindergarten_participation_rate_variation(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      @repo.find_by_name(name).enrollment.kindergarten_participation_by_year
    end

    average(compare[0].values) / average(compare[1].values)
  end

  def kindergarten_participation_rate_variation_trend(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      @repo.find_by_name(name).enrollment.kindergarten_participation_by_year
    end

    matched = match_data(compare[0], compare[1])
    matched[0].merge(matched[1]) { |date, data1, data2| data1 / data2 }
  end

  # def kindergarten_participation_against_high_school_graduation(district)
  #
  # end


  def average(data)
    data.reduce(0) { |sum, data| sum + data } / data.length
  end

  def match_data(first, second)
      [ first.select { |key| second.include?(key) },
      second.select { |key| first.include?(key) } ]
  end

end
