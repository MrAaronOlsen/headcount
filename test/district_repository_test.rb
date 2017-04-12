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

end
