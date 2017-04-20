require_relative 'test_helper'

class LoadTest < MiniTest::Test

  def test_that_it_exists
    assert_instance_of Load, Load.new('./test/fixtures/Median household income.csv')
  end

  def test_it_ids_headers
    loaded = Load.new('./test/fixtures/Median household income.csv')
    parsed = loaded.load_data(:location)

    assert_equal  "Colorado", parsed[0][:location]
  end

  def test_it_parses_csv_file
    loaded = Load.new('./test/fixtures/Median household income.csv')
    parsed = loaded.load_data(:location, :timeframe, :dataformat, :data)

    expected = {:location=>"Colorado", :timeframe=>"2005-2009", :dataformat=>"Currency", :data=>"56222"},
               {:location=>"Colorado", :timeframe=>"2006-2010", :dataformat=>"Currency", :data=>"56456"},
               {:location=>"Colorado", :timeframe=>"2008-2012", :dataformat=>"Currency", :data=>"58244"}

    assert_equal parsed, expected
  end

end
