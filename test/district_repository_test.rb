require_relative 'test_helper'

class DistrictRepositoryTest < MiniTest::Test

  def test_that_it_is_a_district_repository
    assert_instance_of DistrictRepository, DistrictRepository.new
  end

  def test_it_can_find_by_name
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    district = dr.find_by_name("YUMA SCHOOL DISTRICT 1")

    assert_equal "YUMA SCHOOL DISTRICT 1", district.name
  end

  def test_it_cant_find_by_name
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_nil dr.find_by_name("FRIKINFRACK")
  end

  def test_it_can_find_all_matching
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal 7, dr.find_all_matching("WE").count
  end

  def test_it_cant_find_all_matching
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal [], dr.find_all_matching("BZYBUG")
  end

  def test_that_it_gives_districts_enrollment_object
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    assert_in_delta 0.436, district.enrollment.kindergarten_participation_in_year(2010), 0.005
  end

  def test_that_it_gives_districts_statewide_test_object
    dr = DistrictRepository.new
    dr.load_data({:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}
                    })

    district = dr.find_by_name("COLORADO")
    assert_in_delta 0.7094, district.statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2011), 0.005
  end

  def test_that_it_gives_districts_economic_profile_object
    dr = DistrictRepository.new
    dr.load_data({:economic_profile => {
                    :median_household_income => "./data/Median household income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv" }
                  })

    district = dr.find_by_name("ACADEMY 20")
    assert_equal 87635, district.economic_profile.median_household_income_average
  end

end
