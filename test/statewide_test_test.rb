require_relative 'test_helper'

class StatewideTestTest < MiniTest::Test

  def test_that_it_is_a_statewide_test
    assert_instance_of StatewideTest, StatewideTest.new
  end

  def test_can_return_all_third_grade_data
    st = StatewideTest.new({:name=>"COLORADO",
                           :third_grade=>{2008=>0.501, 2009=>0.536, 2010=>0.504, 2011=>0.513, 2012=>0.525, 2013=>0.50947, 2014=>0.51072},
                           :eighth_grade=>{2008=>0.529, 2009=>0.528, 2010=>0.549, 2011=>0.543, 2012=>0.671, 2013=>0.55788, 2014=>0.56183},
                           :math=>{2011=>0.6585, 2012=>0.6618, 2013=>0.6697, 2014=>0.6712},
                           :reading=>{2011=>0.7893, 2012=>0.8021, 2013=>0.7999, 2014=>0.7982},
                           :writing=>{2011=>0.6633, 2012=>0.6447, 2013=>0.6556, 2014=>0.6473}})

    third_grade = {2008=>0.501, 2009=>0.536, 2010=>0.504, 2011=>0.513, 2012=>0.525, 2013=>0.50947, 2014=>0.51072}

    assert_equal third_grade, st.args[:third_grade]
  end

  

end
