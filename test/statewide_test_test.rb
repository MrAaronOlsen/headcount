require_relative 'test_helper'

class StatewideTestTest < MiniTest::Test

  def test_that_it_is_a_statewide_test
    assert_instance_of StatewideTest, StatewideTest.new("googlygoo")
  end

  def test_that_it_groups_year
    st = StatewideTest.new("googlygoo")

    data = [{location: "Colorado", score: "Math", timeframe: "2008", dataformat: "Percent", data: "0.697"},
          {location: "Colorado", score: "Reading", timeframe: "2008", dataformat: "Percent", data: "0.703"},
          {location: "Colorado", score: "Writing", timeframe: "2008", dataformat: "Percent", data: "0.501"},
          {location: "Colorado", score: "Math", timeframe: "2009", dataformat: "Percent", data: "0.234"},
          {location: "Colorado", score: "Reading", timeframe: "2009", dataformat: "Percent", data: "0.232"},
          {location: "Colorado", score: "Writing", timeframe: "2009", dataformat: "Percent", data: "0.567"} ]

    expected = {
     "2008"=>
       [{:location=>"Colorado", :score=>"Math", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.697"},
       {:location=>"Colorado", :score=>"Reading", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.703"},
       {:location=>"Colorado", :score=>"Writing", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.501"}],
     "2009"=>
       [{:location=>"Colorado", :score=>"Math", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.234"},
       {:location=>"Colorado", :score=>"Reading", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.232"},
       {:location=>"Colorado", :score=>"Writing", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.567"}]}


    assert_equal expected, st.scores_grouped_by_year(data)

  end

  def test_that_it_builds_hash_by_score
    st = StatewideTest.new("googlygoo")
    data = [{:location=>"Colorado", :score=>"Math", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.697"},
      {:location=>"Colorado", :score=>"Reading", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.703"},
      {:location=>"Colorado", :score=>"Writing", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.501"}]

    expected = { "Math" => "0.697", "Reading" =>"0.703", "Writing" =>"0.501"}

    assert_equal expected,  st.hash_by_score(data)
  end

  def test_that_it_can_parse_proficieny_by_grade
    st = StatewideTest.new("googlygoo")

    data = [{location: "Colorado", score: "Math", timeframe: "2008", dataformat: "Percent", data: "0.697"},
          {location: "Colorado", score: "Reading", timeframe: "2008", dataformat: "Percent", data: "0.703"},
          {location: "Colorado", score: "Writing", timeframe: "2008", dataformat: "Percent", data: "0.501"},
          {location: "Colorado", score: "Math", timeframe: "2009", dataformat: "Percent", data: "0.234"},
          {location: "Colorado", score: "Reading", timeframe: "2009", dataformat: "Percent", data: "0.232"},
          {location: "Colorado", score: "Writing", timeframe: "2009", dataformat: "Percent", data: "0.567"} ]

          expected = { "2008" => { "Math" => "0.697", "Reading" =>"0.703", "Writing" =>"0.501"},
                       "2009" => { "Math" => "0.234", "Reading" =>"0.232", "Writing" =>"0.567"} }

    assert_equal expected, st.grade_proficiency_process(data)

  end

  def test_that_cant_find_grade
    st = StatewideTest.new("googlygoo")

    assert_equal "No Grade Found", st.proficient_by_grade(10)
  end





  # def test_can_return_all_third_grade_data
  #   st = StatewideTest.new({:name=>"COLORADO",
  #                          :third_grade=>{2008=>0.501, 2009=>0.536, 2010=>0.504, 2011=>0.513, 2012=>0.525, 2013=>0.50947, 2014=>0.51072},
  #                          :eighth_grade=>{2008=>0.529, 2009=>0.528, 2010=>0.549, 2011=>0.543, 2012=>0.671, 2013=>0.55788, 2014=>0.56183},
  #                          :math=>{2011=>0.6585, 2012=>0.6618, 2013=>0.6697, 2014=>0.6712},
  #                          :reading=>{2011=>0.7893, 2012=>0.8021, 2013=>0.7999, 2014=>0.7982},
  #                          :writing=>{2011=>0.6633, 2012=>0.6447, 2013=>0.6556, 2014=>0.6473}})
  #
  #   third_grade = {2008=>0.501, 2009=>0.536, 2010=>0.504, 2011=>0.513, 2012=>0.525, 2013=>0.50947, 2014=>0.51072}
  #
  #   assert_equal third_grade, st.args[:third_grade]
  # end



end
