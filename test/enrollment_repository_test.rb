require_relative 'test_helper'

class EnrollmentRepositoryTest < MiniTest::Test

  def test_that_it_is_an_enrollment_repository
    assert_instance_of EnrollmentRepository, EnrollmentRepository.new
  end

  def test_it_finds_by_name

    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("YUMA SCHOOL DISTRICT 1")
    
    assert_equal enrollment.name, "YUMA SCHOOL DISTRICT 1"
  end



end

# enrollment = er.find_by_name("YUMA SCHOOL DISTRICT 1")
