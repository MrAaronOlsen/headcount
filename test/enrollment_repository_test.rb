require_relative 'test_helper'

class EnrollmentRepositoryTest < MiniTest::Test

  def test_that_it_is_an_enrollment_repository
    assert_instance_of EnrollmentRepository, EnrollmentRepository.new
  end

  def test_that_it_collects_unique_names
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal er.collect_names.count, er.collect_names.uniq.count
  end

  def test_it_finds_by_name
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("YUMA SCHOOL DISTRICT 1")

    assert_instance_of Enrollment, enrollment
    assert_equal enrollment.name, "YUMA SCHOOL DISTRICT 1"
  end

  def test_it_cant_find_by_name
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_nil er.find_by_name("FRIKINFRACK")
  end

  def test_it_returns_correct_kindergarted_participation_by_year_data_by_name
    answer = { 2007 => 0.391, 2006 => 0.353, 2005 => 0.267, 2004 => 0.302,
               2008 => 0.384, 2009 => 0.39, 2010 => 0.436, 2011 => 0.489,
               2012 => 0.478, 2013 => 0.487, 2014 => 0.490 }
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    kp_by_year = er.find_by_name("ACADEMY 20").kindergarten_participation_by_year

    kp_by_year.each do |year, data|
      assert_in_delta answer[year], data, 0.005
    end
  end

  def test_it_returns_correct_kindergarted_participation_in_year_data_by_name
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("ACADEMY 20")

    assert_in_delta 0.267, enrollment.kindergarten_participation_in_year(2005), 0.005
  end

  def test_it_returns_correct_highschool_graduation_in_year_data_by_name
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv" }})
    enrollment = er.find_by_name("ACADEMY 20")

    assert_in_delta 0.895, enrollment.graduation_rate_in_year(2010), 0.005
  end

  def test_it_returns_correct_highschool_graduation_by_year_data_by_name
    answer = { 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898 }
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv" }})
    hsg_by_year = er.find_by_name("ACADEMY 20").graduation_rate_by_year

    hsg_by_year.each do |year, data|
      assert_in_delta answer[year], data, 0.005
    end
  end

end