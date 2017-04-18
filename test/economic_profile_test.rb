require_relative 'test_helper'

class EconomicProfileTest < MiniTest::Test

  def setup
    @data_set_1 = {:name=>"COLORADO",
   :median_houshold_income=>
  [{:location=>"Colorado", :timeframe=>"2005-2009", :dataformat=>"Currency", :data=>"56222"},
   {:location=>"Colorado", :timeframe=>"2006-2010", :dataformat=>"Currency", :data=>"56456"},
   {:location=>"Colorado", :timeframe=>"2008-2012", :dataformat=>"Currency", :data=>"58244"},
   {:location=>"Colorado", :timeframe=>"2007-2011", :dataformat=>"Currency", :data=>"57685"},
   {:location=>"Colorado", :timeframe=>"2009-2013", :dataformat=>"Currency", :data=>"58433"}]}
    @data_set_2 = {:name=>"ACADEMY 20",
   :median_houshold_income=>
  [{:location=>"ACADEMY 20", :timeframe=>"2005-2009", :dataformat=>"Currency", :data=>"85060"},
   {:location=>"ACADEMY 20", :timeframe=>"2006-2010", :dataformat=>"Currency", :data=>"85450"},
   {:location=>"ACADEMY 20", :timeframe=>"2008-2012", :dataformat=>"Currency", :data=>"89615"},
   {:location=>"ACADEMY 20", :timeframe=>"2007-2011", :dataformat=>"Currency", :data=>"88099"},
   {:location=>"ACADEMY 20", :timeframe=>"2009-2013", :dataformat=>"Currency", :data=>"89953"}]}
 end


  def test_that_it_is_an_economic_profile
    ep = EconomicProfile.new(@data_set_1)

    assert_instance_of EconomicProfile, ep
  end

  def test_it_can_form_range_from_string
    ep = EconomicProfile.new(@data_set_1)

    assert_equal [2005, 2006, 2007, 2008, 2009], ep.string_to_range("2005-2009")
  end


end
