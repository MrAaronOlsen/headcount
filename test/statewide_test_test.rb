require_relative 'test_helper'

class StatewideTestTest < MiniTest::Test

  def setup
    @data_sets = { name: 'Colorado',
      third_grade:[
        {location: "Colorado", score: "Math", timeframe: "2008", dataformat: "Percent", data: "0.111"},
        {location: "Colorado", score: "Reading", timeframe: "2008", dataformat: "Percent", data: "0.122"},
        {location: "Colorado", score: "Writing", timeframe: "2008", dataformat: "Percent", data: "0.133"},
        {location: "Colorado", score: "Math", timeframe: "2009", dataformat: "Percent", data: "0.144"},
        {location: "Colorado", score: "Reading", timeframe: "2009", dataformat: "Percent", data: "0.155"},
        {location: "Colorado", score: "Writing", timeframe: "2009", dataformat: "Percent", data: "0.166"}],
      eighth_grade:[
        {location: "Colorado", score: "Math", timeframe: "2008", dataformat: "Percent", data: "0.211"},
        {location: "Colorado", score: "Reading", timeframe: "2008", dataformat: "Percent", data: "0.222"},
        {location: "Colorado", score: "Writing", timeframe: "2008", dataformat: "Percent", data: "0.233"},
        {location: "Colorado", score: "Math", timeframe: "2009", dataformat: "Percent", data: "0.244"},
        {location: "Colorado", score: "Reading", timeframe: "2009", dataformat: "Percent", data: "0.255"},
        {location: "Colorado", score: "Writing", timeframe: "2009", dataformat: "Percent", data: "0.266"}],
      math:[
        {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2011', dataformat: 'Percent', data: '0.1111'},
        {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2011', dataformat: 'Percent', data: '0.1222'},
        {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2012', dataformat: 'Percent', data: '0.1333'},
        {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2012', dataformat: 'Percent', data: '0.1444'}],
      reading:[
        {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2011', dataformat: 'Percent', data: '0.2111'},
        {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2011', dataformat: 'Percent', data: '0.2222'},
        {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2012', dataformat: 'Percent', data: '0.2333'},
        {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2012', dataformat: 'Percent', data: '0.2444'}],
      writing:[
        {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2011', dataformat: 'Percent', data: '0.3111'},
        {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2011', dataformat: 'Percent', data: '0.3222'},
        {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2012', dataformat: 'Percent', data: '0.3333'},
        {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2012', dataformat: 'Percent', data: '0.3444'}]
    }
  end

  def test_that_it_is_a_statewide_test
    assert_instance_of StatewideTest, StatewideTest.new("googlygoo")
  end

  def test_that_it_groups_year
    st = StatewideTest.new("googlygoo")

    expected = {
     "2008"=>
       [{:location=>"Colorado", :score=>"Math", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.111"},
       {:location=>"Colorado", :score=>"Reading", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.122"},
       {:location=>"Colorado", :score=>"Writing", :timeframe=>"2008", :dataformat=>"Percent", :data=>"0.133"}],
     "2009"=>
       [{:location=>"Colorado", :score=>"Math", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.144"},
       {:location=>"Colorado", :score=>"Reading", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.155"},
       {:location=>"Colorado", :score=>"Writing", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.166"}]
     }


    assert_equal expected, st.group_data_by(@data_sets[:third_grade], :timeframe)
  end

  def test_that_it_can_parse_proficieny_by_grade
    st = StatewideTest.new("googlygoo")

    third_grade = { 2008 => { math: 0.111, reading: 0.122, writing: 0.133},
                    2009 => { math: 0.144, reading: 0.155, writing: 0.166} }
    eighth_grade = { 2008 => { math: 0.211, reading: 0.222, writing: 0.233},
                    2009 => { math: 0.244, reading: 0.255, writing: 0.266} }

    assert_equal third_grade, st.grab_proficiency(@data_sets[:third_grade])
    assert_equal eighth_grade, st.grab_proficiency(@data_sets[:eighth_grade])
  end

  def test_that_it_can_find_proficiency_by_grade
    st = StatewideTest.new(@data_sets)

    third_grade = { 2008 => { math: 0.111, reading: 0.122, writing: 0.133},
                    2009 => { math: 0.144, reading: 0.155, writing: 0.166} }
    eighth_grade = { 2008 => { math: 0.211, reading: 0.222, writing: 0.233},
                    2009 => { math: 0.244, reading: 0.255, writing: 0.266} }

    assert_equal third_grade, st.proficient_by_grade(3)
    assert_equal eighth_grade, st.proficient_by_grade(8)
  end

  def test_that_cant_find_grade
    st = StatewideTest.new("googlygoo")

    assert_equal "No Grade Found", st.proficient_by_grade(10)
  end

  def test_that_it_can_match_symbols_with_strings
    st = StatewideTest.new("googlygoo")

    assert st.sym_match?('Asian', :asian)
  end

  def test_that_it_can_grab_race_ethnicity_data
    st = StatewideTest.new(@data_sets)

    expected = {
      :math=>[
        {:location=>"Colorado", :race_ethnicity=>"Asian", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.1111"},
        {:location=>"Colorado", :race_ethnicity=>"Black", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.1222"},
        {:location=>"Colorado", :race_ethnicity=>"Asian", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.1333"},
        {:location=>"Colorado", :race_ethnicity=>"Black", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.1444"}],
      :reading=>[
        {:location=>"Colorado", :race_ethnicity=>"Asian", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.2111"},
        {:location=>"Colorado", :race_ethnicity=>"Black", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.2222"},
        {:location=>"Colorado", :race_ethnicity=>"Asian", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.2333"},
        {:location=>"Colorado", :race_ethnicity=>"Black", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.2444"}],
      :writing=>[
        {:location=>"Colorado", :race_ethnicity=>"Asian", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.3111"},
        {:location=>"Colorado", :race_ethnicity=>"Black", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.3222"},
        {:location=>"Colorado", :race_ethnicity=>"Asian", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.3333"},
        {:location=>"Colorado", :race_ethnicity=>"Black", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.3444"}]
      }

    assert_equal st.grab_race_ethnicity_data, expected
  end

  def test_that_it_can_collect_race_ethnicity_data_by_subject
    st = StatewideTest.new(@data_sets)
    race_data = st.grab_race_ethnicity_data

    expected = {:math=>0.1111, :reading=>0.2111, :writing=>0.3111}

    assert_equal st.collect_race_by_subject(race_data, :asian, '2011'), expected
  end

  def test_that_it_can_collect_race_by_date
    st = StatewideTest.new(@data_sets)
    race_data = st.grab_race_ethnicity_data

    expected = {2011=>{:math=>0.1111, :reading=>0.2111, :writing=>0.3111},
                2012=>{:math=>0.1333, :reading=>0.2333, :writing=>0.3333}}

    assert_equal st.collect_race_by_date(race_data, :asian), expected
  end

  def test_that_it_can_find_proficiency_by_race_or_ethnicity
    st = StatewideTest.new(@data_sets)

    expected = {2011=>{:math=>0.1111, :reading=>0.2111, :writing=>0.3111},
                2012=>{:math=>0.1333, :reading=>0.2333, :writing=>0.3333}}

    assert_equal st.proficient_by_race_or_ethnicity(:asian), expected
  end

  def test_that_it_can_find_proficiency_for_subject_by_grade_in_year
    st = StatewideTest.new(@data_sets)

    assert_in_delta 0.144, st.proficient_for_subject_by_grade_in_year(:math, 3, 2009), 0.005
  end

  def test_that_it_can_find_proficiency_for_subject_by_race_in_year
    st = StatewideTest.new(@data_sets)

    assert_in_delta 0.1111, st.proficient_for_subject_by_race_in_year(:math, :asian, 2011), 0.005
  end

end