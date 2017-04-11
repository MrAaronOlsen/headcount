require_relative 'test_helper'

class StatewideTestRepositoryTest < MiniTest::Test

  def test_that_it_is_a_statewide_test_repository
    assert_instance_of StatewideTestRepository, StatewideTestRepository.new
  end

end