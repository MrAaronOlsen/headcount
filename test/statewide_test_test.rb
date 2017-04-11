require_relative 'test_helper'

class StatewideTestTest < MiniTest::Test

  def test_that_it_is_a_statewide_test
    assert_instance_of StatewideTest, StatewideTest.new
  end

end