require_relative 'test_helper'

class DistrictTest < MiniTest::Test

  def test_that_it_is_a_district
    assert_instance_of District, District.new({:name => "ACADEMY 20"})
  end

  def test_that_district_starts_at_nil
    assert_nil District.new({:name => "ACADEMY 20"}).enrollment
  end

  def test_that_district_hash_name
    d = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name
  end

end
