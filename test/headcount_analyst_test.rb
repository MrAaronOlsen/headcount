require_relative 'test_helper'

class HeadcountAnalystTest < MiniTest::Test

  def test_that_it_is_a_headcount_analyst
    assert_instance_of HeadcountAnalyst, HeadcountAnalyst.new
  end

end