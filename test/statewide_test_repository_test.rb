require_relative 'test_helper'

class StatewideTestRepositoryTest < MiniTest::Test

  def test_that_it_is_a_statewide_test_repository
    assert_instance_of StatewideTestRepository, StatewideTestRepository.new
  end

  def test_that_it_collects_unique_names
  str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"}})

    assert_equal str.collect_names.count, str.collect_names.uniq.count
  end

  def test_it_finds_by_name
    str = StatewideTestRepository.new
      str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"}})
    statewide_test = str.find_by_name("ADAMS COUNTY 14")

    assert_instance_of StatewideTest, statewide_test
    assert_equal statewide_test.name, "ADAMS COUNTY 14"
  end

  def test_it_cant_find_by_name
    str = StatewideTestRepository.new
      str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"}})

    assert_nil str.find_by_name("NEVERLAND")
  end

  def test_it_can_load_dynamic_csvs_1
    str = StatewideTestRepository.new
    loaded = str.load_data({:statewide_testing => {
                      :third_grade => "./test/fixtures/3rd_grade_fixture.csv"}})
    expected = {:third_grade => [{location: "Colorado", score: "Math", timeframe: "2008", dataformat: "Percent", data: "0.697"},
    {location: "Colorado", score: "Reading", timeframe: "2008", dataformat: "Percent", data: "0.703"},
    {location: "Colorado", score: "Writing", timeframe: "2008", dataformat: "Percent", data: "0.501"}]}

    assert_equal expected, loaded
  end

  def test_it_can_load_dynamic_csvs_2
    str = StatewideTestRepository.new
    loaded = str.load_data({:statewide_testing => {
                      :writing => "./test/fixtures/average_proficiency_writing_fixture.csv"}})
    expected = {:writing => [
    {location: "Colorado", race_ethnicity: "All Students",timeframe: "2011",dataformat: "Percent", data: "0.5531"},
    {location: "Colorado", race_ethnicity: "Asian",timeframe: "2011",dataformat: "Percent", data: "0.6569"},
    {location: "Colorado", race_ethnicity: "Black",timeframe: "2011",dataformat: "Percent", data: "0.3701"},
    {location: "Colorado", race_ethnicity: "Hawaiian/Pacific Islander",timeframe: "2011",dataformat: "Percent", data: "0.5583"},
    {location: "Colorado", race_ethnicity: "Hispanic",timeframe: "2011",dataformat: "Percent", data: "0.368"},
    {location: "Colorado", race_ethnicity: "Native American",timeframe: "2011",dataformat: "Percent", data: "0.3788"},
    {location: "Colorado", race_ethnicity: "Two or more",timeframe: "2011",dataformat: "Percent", data: "0.6169"},
    {location: "Colorado", race_ethnicity: "White",timeframe: "2011",dataformat: "Percent", data: "0.6633"}]}


    assert_equal expected, loaded
  end
  # def test_it_returns_correct_statewide_test_scores_in_year_data_by_name
  #   answer = { 2007 => 0.391, 2006 => 0.353, 2005 => 0.267, 2004 => 0.302,
  #              2008 => 0.384, 2009 => 0.39, 2010 => 0.436, 2011 => 0.489,
  #              2012 => 0.478, 2013 => 0.487, 2014 => 0.490 }
  #   er = EnrollmentRepository.new
  #   er.load_data({:enrollment => {
  #                   :kindergarten => "./data/Kindergartners in full-day program.csv"}})
  #   kp_by_year = er.find_by_name("ACADEMY 20").kindergarten_participation_by_year
  #
  #   kp_by_year.each do |year, data|
  #     assert_in_delta answer[year], data, 0.005
  #   end
  # end

  # def test_that_it_has_a_statewide_test_repository
  #   str = StatewideTestRepository.new
  #   str.load_data({
  #     :statewide_testing => {
  #       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
  #       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
  #       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
  #       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
  #       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  #     }
  #   })
  #   str = str.find_by_name("ACADEMY 20")
  #
  #   assert_equal "ACADEMY 20" , str.find_by_name("ACADEMY 20").name
  # end

end
