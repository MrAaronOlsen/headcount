require_relative 'test_helper'

class EnrollmentTest < MiniTest::Test

  def test_that_it_is_an_enrollment
    assert_instance_of Enrollment, Enrollment.new
  end

end