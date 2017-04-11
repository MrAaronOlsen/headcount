require_relative 'test_helper'

class EconomicProfileTest < MiniTest::Test

  def test_that_it_is_an_economic_profile
    assert_instance_of EconomicProfile, EconomicProfile.new
  end

end