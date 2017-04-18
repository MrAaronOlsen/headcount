require_relative 'test_helper'

class EconomicProfileRepositoryTest < MiniTest::Test

  def test_that_it_is_an_economic_profile_repository
    assert_instance_of EconomicProfileRepository, EconomicProfileRepository.new
  end

  def test_that_it_collects_unique_names
  epr = EconomicProfileRepository.new
    epr.load_data({:economic_profile => {
                    :median_houshold_income => "./test/fixtures/median_household_income.csv"}})

    assert_equal epr.collect_names.count, epr.collect_names.uniq.count
  end

  def test_it_finds_by_name
    epr = EconomicProfileRepository.new
      epr.load_data({:economic_profile => {
                      :median_houshold_income => "./test/fixtures/median_household_income.csv"}})
    economic_profile = epr.find_by_name("ADAMS COUNTY 14")

    assert_instance_of EconomicProfile, economic_profile
    assert_equal economic_profile.name, "ADAMS COUNTY 14"
  end

  def test_it_cant_find_by_name
    epr = EconomicProfileRepository.new
      epr.load_data({:economic_profile => {
                      :median_houshold_income => "./test/fixtures/median_household_income.csv"}})

    assert_nil epr.find_by_name("GAMEHENDGE")
  end

  def test_it_finds_by_name_in_different_csv
    epr = EconomicProfileRepository.new
      epr.load_data({:economic_profile => {
                      :median_houshold_income => "./test/fixtures/students_qualifying_fixture.csv"}})
    economic_profile = epr.find_by_name("ADAMS COUNTY 14")

    assert_instance_of EconomicProfile, economic_profile
    assert_equal economic_profile.name, "ADAMS COUNTY 14"
  end




end
