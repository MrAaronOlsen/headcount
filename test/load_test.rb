require_relative 'test_helper'

class LoadTest < MiniTest::Test

  def test_that_it_exists
    assert_instance_of Load, Load.new('../data/Median household income')
  end

  def test_it_ids_headers
    loaded = Load.new('data/Median household income.csv')
    parsed = loaded.parsable_file

    assert_equal  "Colorado" , parsed.first[:location]
  end
end


#Location,Category,TimeFrame,DataFormat,Data
