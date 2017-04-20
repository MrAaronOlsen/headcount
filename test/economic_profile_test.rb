require_relative 'test_helper'

class EconomicProfileTest < MiniTest::Test

  def setup
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income.csv",
        :children_in_poverty => "./test/fixtures/school_aged_children_fixture.csv",
        :free_or_reduced_price_lunch => "./test/fixtures/students_qualifying_fixture.csv",
        :title_i => "./test/fixtures/title_i_fixture.csv"
      }
    })
    @ep = epr.find_by_name("ACADEMY 20")
  end

  def test_that_it_is_an_economic_profile
    assert_instance_of EconomicProfile, @ep
  end

  def test_that_it_calculates_mean_income_in_year
    assert_equal 86203, @ep.median_household_income_in_year(2007)
  end

  def test_it_can_find_amalgam_mean_income
    assert_equal 87635, @ep.median_household_income_average
  end

  def test_it_can_find_poverty_percentage_in_year
    assert_equal 0.04714, @ep.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_it_can_find_reduced_lunch_price_percentage_in_year
    assert_equal 0.04714, @ep.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_it_can_find_reduced_lunch_price_number_in_year
    assert_equal 3678, @ep.free_or_reduced_price_lunch_number_in_year(2001)
  end

  def test_it_can_raise_error_for_poverty_percentage
    exception = assert_raises(UnknownDataError) { @ep.free_or_reduced_price_lunch_number_in_year(1312) }
    assert_equal 'unknown year', exception.message
  end

  def test_it_can_find_title_i_in_year
    assert_equal 0.71053, @ep.title_i_in_year(2012)
  end

  def test_it_can_raise_error_for_title_i
    exception = assert_raises(UnknownDataError) { @ep.title_i_in_year(1312) }
    assert_equal 'unknown year', exception.message
  end
end
