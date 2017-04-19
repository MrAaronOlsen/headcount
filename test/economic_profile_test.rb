require_relative 'test_helper'

class EconomicProfileTest < MiniTest::Test

  def setup
    @household_income_data_setup =
    {:name=>"COLORADO",
      :median_houshold_income=>
       [{:location=>"Colorado", :timeframe=>"2005-2009", :dataformat=>"Currency", :data=>"56222"},
       {:location=>"Colorado", :timeframe=>"2006-2010", :dataformat=>"Currency", :data=>"56456"},
       {:location=>"Colorado", :timeframe=>"2008-2012", :dataformat=>"Currency", :data=>"58244"},
       {:location=>"Colorado", :timeframe=>"2007-2011", :dataformat=>"Currency", :data=>"57685"},
       {:location=>"Colorado", :timeframe=>"2009-2013", :dataformat=>"Currency", :data=>"58433"}]}
    @child_poverty_data_setup =
    {:name=>"ACADEMY 20",
     :children_in_poverty=>
     [{:location=>"ACADEMY 20", :timeframe=>"2006", :dataformat=>"Percent", :data=>"0.036"},
      {:location=>"ACADEMY 20", :timeframe=>"2007", :dataformat=>"Percent", :data=>"0.039"},
      {:location=>"ACADEMY 20", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.04404"},
      {:location=>"ACADEMY 20", :timeframe=>"2008", :dataformat=>"Number", :data=>"855"},
      {:location=>"ACADEMY 20", :timeframe=>"2009", :dataformat=>"Number", :data=>"921"},
      {:location=>"ACADEMY 20", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.047"},
      {:location=>"ACADEMY 20", :timeframe=>"2010", :dataformat=>"Number", :data=>"1251"},
      {:location=>"ACADEMY 20", :timeframe=>"2010", :dataformat=>"Percent", :data=>"0.05754"},
      {:location=>"ACADEMY 20", :timeframe=>"2011", :dataformat=>"Number", :data=>"1279"}]}
 end


  def test_that_it_is_an_economic_profile
    ep = EconomicProfile.new(@household_income_data_setup)

    assert_instance_of EconomicProfile, ep
  end

  def test_it_can_form_range_from_string
    ep = EconomicProfile.new(@household_income_data_setup)

    assert_equal [2005, 2006, 2007, 2008, 2009], ep.string_to_range("2005-2009")
  end

  def test_that_it_calculates_mean_income_in_year
    ep = EconomicProfile.new(@household_income_data_setup)

    assert_equal 56787, ep.median_household_income_in_year(2007)
  end

  def test_it_can_find_amalgam_mean_income
    ep = EconomicProfile.new(@household_income_data_setup)

    assert_equal 57408, ep.median_household_income_average
  end

  def test_it_can_find_poverty_percentage_in_year
    ep = EconomicProfile.new(@child_poverty_data_setup)

    assert_equal 0.04404, ep.children_in_poverty_in_year(2008)
  end



end
