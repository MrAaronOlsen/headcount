require_relative 'test_helper'

class LoadTest < MiniTest::Test

  def test_that_it_exists
    assert_instance_of Load, Load.new('../data/Median household income')
  end

  def test_it_ids_headers
    loaded = Load.new('data/Median household income.csv')
    parsed = loaded.load_data(:location)
    
    assert_equal  "Colorado" , parsed[0].first[:location]
  end
end