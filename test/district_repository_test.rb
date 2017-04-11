require_relative 'test_helper'

class DistrictRepositoryTest < MiniTest::Test

  def test_that_it_is_a_district_repository
    assert_instance_of DistrictRepository, DistrictRepository.new
  end

  def test_it_can_find_by_name
    skip
    dr = DistrictRepository.new
    d = District.new("Academy 20")

    assert_equal d, dr.find_by_name("Academy 20")
  end



  def test_loading_and_finding_districts
    skip
    dr = DistrictRepository.new
    dr.load_data({
                   :enrollment => {
                     :kindergarten => "./data/Kindergartners in full-day program.csv"
                   }
                 })
    district = dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name

    assert_equal 7, dr.find_all_matching("WE").count
  end


end
