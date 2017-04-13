require_relative 'test_helper'

class EnrollmentTest < MiniTest::Test

  def setup
    @enrollment = {:name => "ACADEMY 20",
                   :kindergarten_participation => { 2010 => 0.3915,
                                                    2011 => 0.35356,
                                                    2012 => 0.2677 },
                   :high_school_graduation => { 2010 => 0.895,
                                               2011 => 0.895,
                                               2012 => 0.889,
                                               2013 => 0.913,
                                               2014 => 0.898 }
                  }
  end

  def test_that_it_is_an_enrollment
    assert_instance_of Enrollment, Enrollment.new(@enrollment)
  end

  def test_that_it_has_a_name
    assert_equal Enrollment.new(@enrollment).name, "ACADEMY 20"
  end

  def test_that_it_finds_in_year
    e = Enrollment.new(@enrollment)
    assert_in_delta 0.391, e.kindergarten_participation_in_year(2010), 0.005
    assert_in_delta 0.895, e.graduation_rate_in_year(2010), 0.005
  end

  def test_that_cant_find_in_year
    e = Enrollment.new(@enrollment)
    assert_nil e.kindergarten_participation_in_year(2014)
  end

  def test_that_it_finds_by_year
    e = Enrollment.new(@enrollment)
    assert_equal e.kindergarten_participation_by_year, { 2010 => 0.3915,
                                                         2011 => 0.35356,
                                                         2012 => 0.2677 }
    assert_equal e.graduation_rate_by_year, { 2010 => 0.895,
                                              2011 => 0.895,
                                              2012 => 0.889,
                                              2013 => 0.913,
                                              2014 => 0.898 }
  end


end