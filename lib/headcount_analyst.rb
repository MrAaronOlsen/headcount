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

  def high_school_graduation_rate_variation(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      @repo.find_by_name(name).enrollment.graduation_rate_by_year
    end

    average(compare[0].values) / average(compare[1].values)
  end

  def high_school_graduation_rate_variation_trend(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      @repo.find_by_name(name).enrollment.graduation_rate_by_year
    end

    matched = match_data(compare[0], compare[1])
    matched[0].merge(matched[1]) { |date, data1, data2| data1 / data2 }
  end

  def kindergarten_participation_against_high_school_graduation(loc)
    kindergarten_participation_rate_variation(loc, :against => 'COLORADO')/
    high_school_graduation_rate_variation(loc, :against => 'COLORADO')
  end

  alias :kp_v_hsg
    :kindergarten_participation_against_high_school_graduation

  def kindergarten_participation_correlates_with_high_school_graduation(loc)
    loc[:across], loc[:for] = @repo.all_names, nil if loc[:for] == 'STATEWIDE'

    if loc[:across].nil?
      correlation?(kp_v_hsg(loc[:for]))
    else
      predict?(kp_cor_hsg_range_percent(loc[:across]))
    end
  end

  alias :kp_cor_hsg
    :kindergarten_participation_correlates_with_high_school_graduation

  def kp_cor_hsg_range_percent(range)
    correlations = range.map { |loc| kp_cor_hsg(:for => loc) }
    percent( correlations.count(true), correlations.count )
  end

  def predict?(percentage)
    percentage > 70.0
  end

  def correlation?(percentage)
    percentage >= 0.6 && percentage <= 1.5
  end

  def percent(num1, num2)
    return num1 if num2.zero?
    (num1 / num2) * 100
  end

  def average(data)
    data.reduce(0) { |sum, data| sum + data } / data.length
  end

  def match_data(first, second)
      [ first.select { |key| second.include?(key) },
      second.select { |key| first.include?(key) } ]
  end

end