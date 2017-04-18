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


    assert_equal expected, st.group_data_by(data, :timeframe)

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

    assert_equal expected, st.grab_proficiency(data)

  end

  def test_that_cant_find_grade
    st = StatewideTest.new("googlygoo")

    assert_equal "No Grade Found", st.proficient_by_grade(10)
  end

end
