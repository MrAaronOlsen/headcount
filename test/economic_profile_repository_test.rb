require_relative 'test_helper'

class EconomicProfileRepositoryTest < MiniTest::Test

  def test_that_it_is_an_economic_profile_repository
    assert_instance_of EconomicProfileRepository, EconomicProfileRepository.new
  end

end