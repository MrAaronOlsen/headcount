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
    statewide_test = str.find_by_name("YUMA SCHOOL DISTRICT 1")

    assert_instance_of StatewideTest, statewide_test
    assert_equal statewide_test.name, "YUMA SCHOOL DISTRICT 1"
  end

  def test_it_cant_find_by_name
    str = StatewideTestRepository.new
      str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"}})

    assert_nil str.find_by_name("NEVERLAND")
  end

  def test_that_it_has_a_statewide_test_repository
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    str = str.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20" , str.find_by_name("ACADEMY 20").name
  end

end
