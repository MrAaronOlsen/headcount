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

    assert_equal "ACADEMY 20" , ha.find_by_name("ACADEMY 20").name
  end

  def test_that_it_can_find_percent_in_a_range
    ha = HeadcountAnalyst.new('DoopyDo')
    range = [false, false, true, true, false, true, true, false]

    assert_equal 50.0, ha.percent_of_range(range, true)
  end

  def test_that_it_can_predict_significance
    ha = HeadcountAnalyst.new('DoopyDo')

    assert ha.predict?(70.1)
    refute ha.predict?(60.9)
  end

  def test_that_it_can_find_correlation
    ha = HeadcountAnalyst.new('DoopyDo')

    assert ha.correlation?(0.6)
    assert ha.correlation?(1.5)
    refute ha.correlation?(0.59)
    refute ha.correlation?(1.51)
  end

  def test_that_it_can_find_percentiles
    ha = HeadcountAnalyst.new('DoopyDo')

    assert_in_delta 41.66, ha.percent(5.0, 12.0), 0.05
    assert_in_delta 10.00, ha.percent(10.0, 0), 0.05
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
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_that_it_correlates_kindergarten_and_highschool_range
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv" }})
    ha = HeadcountAnalyst.new(dr)
    districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  end

  def test_that_it_collects_districts_by_grade
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./test/fixtures/3rd_grade_analyst_fixture.csv",
                    :eighth_grade => "./test/fixtures/8th_grade_analyst_fixture.csv" })

    expected = {"COLORADO"=> {
                  2008=>{:math=>0.697, :reading=>0.703, :writing=>0.501},
                  2009=>{:math=>0.691, :reading=>0.726, :writing=>0.536},
                  2010=>{:math=>0.706, :reading=>0.698, :writing=>0.504},
                  2011=>{:math=>0.696, :reading=>0.728, :writing=>0.513},
                  2012=>{:reading=>0.739, :math=>0.71, :writing=>0.525},
                  2013=>{:math=>0.72295, :reading=>0.73256, :writing=>0.50947},
                  2014=>{:math=>0.71589, :reading=>0.71581, :writing=>0.51072}},
                "ACADEMY 20"=> {
                  2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                  2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                  2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                  2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                  2012=>{:reading=>0.87, :math=>0.83, :writing=>0.65517},
                  2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687},
                  2014=>{:math=>0.8345, :reading=>0.83101, :writing=>0.63942}}
                }

    ha = HeadcountAnalyst.new(dr)
    assert_equal ha.collect_districts_by_grade(3), expected
  end

  def test_that_it_collects_subject_by_minmax_year
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./test/fixtures/3rd_grade_analyst_fixture.csv",
                    :eighth_grade => "./test/fixtures/8th_grade_analyst_fixture.csv" })

    ha = HeadcountAnalyst.new(dr)
    data = ha.collect_districts_by_grade(3)

    expected = {"COLORADO"=> {
                  2008=>{:math=>0.697, :reading=>0.703, :writing=>0.501},
                  2014=>{:math=>0.71589, :reading=>0.71581, :writing=>0.51072}},
                "ACADEMY 20"=> {
                  2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                  2014=>{:math=>0.8345, :reading=>0.83101, :writing=>0.63942}}
                }

    assert_equal ha.collect_districts_by_minmax_year(data), expected
  end

  def test_that_it_can_scub_invalid_data_from_data_set
    data_set = {"COLORADO"=> {
                  2008=>{:math=>'#VALUE!', :reading=>0.703, :writing=>0.501},
                  2009=>{:math=>0.691, :reading=>0.726, :writing=>0.536},
                  2010=>{:math=>0.706, :reading=>0.698, :writing=>0.504},
                  2011=>{:math=>'ACK!', :reading=>0.728, :writing=>0.513},
                  2012=>{:reading=>0.739, :math=>0.71, :writing=>0.525},
                  2013=>{:math=>0.72295, :reading=>0.73256, :writing=>0.50947},
                  2014=>{:math=>'#VALUE!', :reading=>0.71581, :writing=>0.51072}},
                "ACADEMY 20"=> {
                  2008=>{:math=>'n/a', :reading=>0.866, :writing=>0.671},
                  2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                  2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                  2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                  2012=>{:reading=>0.823, :math=>'#VALUE!', :writing=>0.65517},
                  2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687},
                  2014=>{:math=>'N/A', :reading=>0.83101, :writing=>0.63942}}
                }

    expected = {"COLORADO"=> {
                  2009=>{:math=>0.691, :reading=>0.726, :writing=>0.536},
                  2010=>{:math=>0.706, :reading=>0.698, :writing=>0.504},
                  2012=>{:reading=>0.739, :math=>0.71, :writing=>0.525},
                  2013=>{:math=>0.72295, :reading=>0.73256, :writing=>0.50947}},
                "ACADEMY 20"=> {
                  2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                  2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                  2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                  2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687}}
                }

    ha = HeadcountAnalyst.new('boopydo')

    assert_equal ha.scrub_invalid_data_by_subject(data_set, :math), expected
  end

  def test_that_it_can_deal_with_no_data
    data_set = {"COLORADO"=> {
                  2008=>{:math=>'#VALUE!', :reading=>0.703, :writing=>0.501},
                  2009=>{:math=>'#VALUE!', :reading=>0.726, :writing=>0.536},
                  2010=>{:math=>'#VALUE!', :reading=>0.698, :writing=>0.504},
                  2011=>{:math=>'ACK!', :reading=>0.728, :writing=>0.513},
                  2012=>{:reading=>'#VALUE!', :math=>'#VALUE!', :writing=>0.525},
                  2013=>{:math=>'#VALUE!', :reading=>0.73256, :writing=>0.50947},
                  2014=>{:math=>'#VALUE!', :reading=>0.71581, :writing=>0.51072}},
                "ACADEMY 20"=> {
                  2008=>{:math=>'n/a', :reading=>0.866, :writing=>0.671},
                  2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                  2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                  2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                  2012=>{:reading=>0.823, :math=>'#VALUE!', :writing=>0.65517},
                  2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687},
                  2014=>{:math=>'N/A', :reading=>0.83101, :writing=>0.63942}}
                }

    expected = {"ACADEMY 20"=> {
                  2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                  2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                  2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                  2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687}}
                }

    ha = HeadcountAnalyst.new('boopydo')
    assert_equal ha.scrub_invalid_data_by_subject(data_set, :math), expected
  end

  def test_that_it_can_calculate_growth
    ha = HeadcountAnalyst.new('boopydo')
    query = { 2008=>{:math=>0.697, :reading=>0.703, :writing=>0.501},
              2014=>{:math=>0.71589, :reading=>0.71581, :writing=>0.51072} }

    assert_in_delta 0.003, ha.calc_growth(query, :math), 0.005
  end

  def test_that_it_can_find_growths_by_subject
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./test/fixtures/3rd_grade_analyst_fixture.csv",
                    :eighth_grade => "./test/fixtures/8th_grade_analyst_fixture.csv" })
    ha = HeadcountAnalyst.new(dr)
    by_grade = ha.collect_districts_by_grade(3)
    minmax = ha.collect_districts_by_minmax_year(by_grade)

    expected = {"COLORADO"=>0.003, "ACADEMY 20"=>-0.003}
    actual = ha.find_growths_by_subject(minmax, :math)

    actual.each do |dist, growth|
      assert_in_delta expected[dist], growth, 0.005
    end
  end

  def test_that_can_find_top_growth_by_grade_subject
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv" })

    ha = HeadcountAnalyst.new(dr)

    assert_equal "WILEY RE-13 JT", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math).first
    assert_in_delta 0.3, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math).last, 0.005

    assert_equal "COTOPAXI RE-3", ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).first
    assert_in_delta 0.13, ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).last, 0.005

    assert_equal "BETHUNE R-5", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).first
    assert_in_delta 0.148, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).last, 0.005
  end

  def test_that_it_raises_errors
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)

    assert_raises(InsufficientInformationError) do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end

    assert_raises(UnknownDataError) do
      ha.top_statewide_test_year_over_year_growth({grade: 6, subject: :math})
    end
  end

  def test_that_it_returns_more_than_one_top_district
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv" })

    ha = HeadcountAnalyst.new(dr)

    assert_equal "WILEY RE-13 JT", ha.top_statewide_test_year_over_year_growth(grade: 3, top: 2, subject: :math)[1].first
    assert_in_delta 0.3, ha.top_statewide_test_year_over_year_growth(grade: 3, top: 2, subject: :math)[1].last, 0.005

    assert_equal "OTIS R-3", ha.top_statewide_test_year_over_year_growth(grade: 3, top: 2, subject: :reading)[0].first
    assert_in_delta 0.081, ha.top_statewide_test_year_over_year_growth(grade: 3, top: 2, subject: :reading)[0].last, 0.005
  end

  def test_that_it_collect_all_subjects
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./test/fixtures/3rd_grade_analyst_dirty_fixture.csv"})
    ha = HeadcountAnalyst.new(dr)

    expected = [[["ACADEMY 20", 0.002], ["BAYFIELD 10 JT-R", 0.005]],
                [["ACADEMY 20", -0.001], ["BAYFIELD 10 JT-R", 0.001]],
                [["ACADEMY 20", -0.009], ["BAYFIELD 10 JT-R", 0.012]]]

    ha.collect_growth_across_all_subjects(3)[0].each_with_index do |line, i|
      assert_in_delta expected[0][i][1], line[1], 0.005
    end

    ha.collect_growth_across_all_subjects(3)[0].each_with_index do |line, i|
      assert_equal expected[0][i][0], line[0]
    end

  end

  def test_that_it_finds_top_growth_by_grade
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./test/fixtures/3rd_grade_analyst_dirty_fixture.csv"})
    ha = HeadcountAnalyst.new(dr)

    expected = ["BAYFIELD 10 JT-R", 0.006537777777777777]

    assert_equal ha.find_top_growth_by_grade(3), expected
  end


  def test_that_it_can_find_top_growth_by_grade
    dr = DistrictRepository.new
    dr.load_data(:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv" })

    ha = HeadcountAnalyst.new(dr)

    assert_equal "SANGRE DE CRISTO RE-22J", ha.top_statewide_test_year_over_year_growth(grade: 3).first
    assert_in_delta 0.071, ha.top_statewide_test_year_over_year_growth(grade: 3).last, 0.005

    assert_equal "OURAY R-1", ha.top_statewide_test_year_over_year_growth(grade: 8).first
    assert_in_delta 0.11, ha.top_statewide_test_year_over_year_growth(grade: 8).last, 0.005
  end

end