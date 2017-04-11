require_relative 'test_helper'

class DistrictTest < MiniTest::Test

  def test_that_it_is_a_district
    assert_instance_of District, District.new({:name => "ACADEMY 20"})
  end

  def test_district_basics
    d = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name
  end
end
