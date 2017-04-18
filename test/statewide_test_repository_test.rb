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
    {location: "Colorado", race_ethnicity: "Black",timeframe: "2011",dataformat: "Percent", data: "0.3701"}]}

    assert_equal expected, loaded
  end

  def test_it_can_give_districts_data
    str = StatewideTestRepository.new
    loaded = str.load_data({:statewide_testing => {
                      :third_grade => "./test/fixtures/3rd_grade_fixture.csv",
                      :writing => "./test/fixtures/average_proficiency_writing_fixture.csv"}})
    expected = { name: "COLORADO",
    :third_grade =>
      [ {location: "Colorado", score: "Math", timeframe: "2008", dataformat: "Percent", data: "0.697"},
        {location: "Colorado", score: "Reading", timeframe: "2008", dataformat: "Percent", data: "0.703"},
        {location: "Colorado", score: "Writing", timeframe: "2008", dataformat: "Percent", data: "0.501"} ],
    :writing =>
      [ {location: "Colorado", race_ethnicity: "All Students",timeframe: "2011",dataformat: "Percent", data: "0.5531"},
        {location: "Colorado", race_ethnicity: "Asian",timeframe: "2011",dataformat: "Percent", data: "0.6569"},
        {location: "Colorado", race_ethnicity: "Black",timeframe: "2011",dataformat: "Percent", data: "0.3701"}]
    }

    assert_equal expected, str.find_by_name('COLORADO').data
  end

  def test_it_loads_all_files
    str = StatewideTestRepository.new
      str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})

      assert_equal "COLORADO", str.find_by_name("COLORADO").name
  end

end
