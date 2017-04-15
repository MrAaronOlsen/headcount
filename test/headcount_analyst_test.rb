require_relative 'test_helper'

class HeadcountAnalystTest < MiniTest::Test

  def test_that_it_is_a_headcount_analyst
    assert_instance_of HeadcountAnalyst, HeadcountAnalyst.new('dr')
  end

  def test_that_it_has_a_district_repository
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_instance_of DistrictRepository, ha.repo
    assert_equal "ACADEMY 20" , ha.repo.find_by_name("ACADEMY 20").name
  end

  def test_that_it_can_find_percentiles
    ha = HeadcountAnalyst.new('DoopyDo')

    assert_in_delta 41.66, ha.percent(5.0, 12.0), 0.05
  end

  def test_that_it_can_average_data
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    data = [20.34, 34.98, 15.0, 15.34, 60.023]

    assert_in_delta 29.136, ha.average(data), 0.005
  end

  def test_that_it_can_match_data
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    districts = [ { 2010 => 2.0, 2011 => 3.0, 2012 => 4.0, 2013 => 5.0 },
                  { 2010 => 1.0, 2011 => 1.5, 2012 => 2.0, 2015 => 3.5, 2013 => 2.5 } ]

    expected = [ {2010=>2.0, 2011=>3.0, 2012=>4.0, 2013=>5.0},
                 {2010=>1.0, 2011=>1.5, 2012=>2.0, 2013=>2.5} ]

    assert_equal ha.match_data(districts[0], districts[1]), expected
  end

  def test_it_can_compare_kindergarted_participation_rates
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_in_delta 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO'), 0.005
    assert_in_delta 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end

  def test_it_can_compare_kindergarted_participation_trends
    answer = { 2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992,
               2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727,
               2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    solution = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    answer.each do |k,v|
      assert_in_delta v, solution[k], 0.005
    end

  end

  def test_it_can_compare_highschool_graduation_rates
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv" }})
    ha = HeadcountAnalyst.new(dr)

    assert_in_delta 1.195, ha.high_school_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO'), 0.005
  end

  def test_it_can_compare_high_school_graduation_trends
    answer = { 2010 => 1.236, 2011 => 1.211,
               2012 => 1.18, 2013 => 1.188, 2014 => 1.161 }

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv" }})
    ha = HeadcountAnalyst.new(dr)
    solution = ha.high_school_graduation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    answer.each do |k,v|
      assert_in_delta v, solution[k], 0.005
    end
  end

  def test_that_it_compare_kindergarten_rates_against_high_school_rates
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv" }})
    ha = HeadcountAnalyst.new(dr)

    assert_in_delta 0.641, ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20"), 0.005
  end

  def test_that_it_correlates_kindergarten_and_highschool
  dr = DistrictRepository.new
  dr.load_data({:enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv",
                  :high_school_graduation => "./data/High school graduation rates.csv" }})
  ha = HeadcountAnalyst.new(dr)

  assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_that_it_correlates_kindergarten_and_highschool_statewide
  dr = DistrictRepository.new
  dr.load_data({:enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv",
                  :high_school_graduation => "./data/High school graduation rates.csv" }})
  ha = HeadcountAnalyst.new(dr)

  assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

end
