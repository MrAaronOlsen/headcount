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

    assert_instance_of DistrictRepository, ha.district_repository
    assert_equal "ACADEMY 20" , ha.district_repository.find_by_name("ACADEMY 20").name
  end

  def test_that_it_can_average_data
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    data = [20.34, 34.98, 15.0, 15.34, 60.023]

    assert_in_delta 29.136, ha.average(data), 0.005
  end

  def test_it_can_compare_averages
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_in_delta 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO'), 0.005
    assert_in_delta 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end

  def test_a_thing
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end
end
