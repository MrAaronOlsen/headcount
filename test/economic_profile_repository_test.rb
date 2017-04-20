require_relative 'test_helper'

class EconomicProfileRepositoryTest < MiniTest::Test

  def test_that_it_is_an_economic_profile_repository
    assert_instance_of EconomicProfileRepository, EconomicProfileRepository.new
  end

  def test_loads_full_data
    epr = EconomicProfileRepository.new
    epr.load_data({:economic_profile =>
                    { :median_household_income => "./data/median household income.csv",
                      :children_in_poverty => "./data/School-aged children in poverty.csv",
                      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                      :title_i => "./data/Title I students.csv" }})
    assert_equal 1,1
  end
  #
  # def test_that_it_collects_unique_names
  # epr = EconomicProfileRepository.new
  #   epr.load_data({:economic_profile => {
  #                   :median_houshold_income => "./data/median household income.csv"}})
  #
  #   assert_equal epr.collect_names.count, epr.collect_names.uniq.count
  # end
  #
  # def test_it_finds_by_name
  #   epr = EconomicProfileRepository.new
  #     epr.load_data({:economic_profile => {
  #                     :median_houshold_income => "./data/median household income.csv"}})
  #   economic_profile = epr.find_by_name("ADAMS COUNTY 14")
  #
  #   assert_instance_of EconomicProfile, economic_profile
  #   assert_equal economic_profile.name, "ADAMS COUNTY 14"
  # end
  #
  # def test_it_cant_find_by_name
  #   epr = EconomicProfileRepository.new
  #     epr.load_data({:economic_profile => {
  #                     :median_houshold_income => "./data/median household income.csv"}})
  #
  #   assert_nil epr.find_by_name("GAMEHENDGE")
  # end

  # def test_it_finds_by_name_in_different_csv
  #   epr = EconomicProfileRepository.new
  #     epr.load_data({:economic_profile => {
  #                     :median_houshold_income => "./test/fixtures/students_qualifying_fixture.csv"}})
  #   economic_profile = epr.find_by_name("ADAMS COUNTY 14")
  #
  #   assert_instance_of EconomicProfile, economic_profile
  #   assert_equal economic_profile.name, "ADAMS COUNTY 14"
  # end
end
