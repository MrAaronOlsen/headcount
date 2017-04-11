require_relative 'test_helper'

class EnrollmentRepositoryTest < MiniTest::Test

  def test_that_it_is_an_enrollment_repository
    assert_instance_of EnrollmentRepository, EnrollmentRepository.new
  end

end