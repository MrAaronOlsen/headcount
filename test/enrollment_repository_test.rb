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

    assert_instance_of Enrollment, enrollment
    assert_equal enrollment.name, "YUMA SCHOOL DISTRICT 1"
  end

  def test_it_cant_find_by_name
    skip
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_nil er.find_by_name("FRIKINFRACK")
  end

  def test_it_returns_correct_kindergarted_participation_by_year_data_by_name
    answer = { 2007 => 0.39159, 2006 => 0.35364, 2005 => 0.26709, 2004 => 0.30201,
               2008 => 0.38456, 2009 => 0.39, 2010 => 0.43628, 2011 => 0.489,
               2012 => 0.47883, 2013 => 0.48774, 2014 => 0.49022 }

    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal enrollment.kindergarten_participation_by_year, answer
  end

  def test_it_returns_correct_kindergarted_participation_in_year_data_by_name
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("ACADEMY 20")

    assert_in_delta 0.267, enrollment.kindergarten_participation_in_year(2005), 0.005
  end

  def test_that_it_gives_district_data
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    district = District.new( {:name => "ACADEMY 20"} )
    er.give_district_data(district)

    assert_instance_of Enrollment, district.enrollment
    assert_in_delta 0.267, district.enrollment.kindergarten_participation_in_year(2005), 0.005
  end



end
