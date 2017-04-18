require_relative 'unknown_data_error'
require_relative 'unknown_race_error'
require_relative 'headcount_helper'
require_relative 'enums'

class StatewideTest

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def name
    @data[:name]
  end

  def proficient_by_grade(grade)
    grades = {3 => :third_grade, 8 => :eighth_grade}
    unless grades[grade].nil?
      grab_proficiency(@data[grades[grade]])
    else
      "No Grade Found"
    end
  end

  def proficient_by_race_or_ethnicity(race)
    race_data = grab_race_ethnicity_data
    collect_race_by_date(race_data, race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    proficient_by_grade(grade)[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    proficient_by_race_or_ethnicity(race)[year][subject]
  end

  def grab_proficiency(grade_data)
    grouped = group_data_by(grade_data, :timeframe)

    grouped.hash_map do |year, data|
      {year.to_i => data.hash_map { |line| { line[:score] => line[:data].to_f } } }
    end
  end

  def grab_race_ethnicity_data
    [:math, :reading, :writing].hash_map do |subject|
      {subject => @data[subject]}
    end
  end

  def collect_race_by_date(race_data, race)
    collected = {}
    race_data.each do |type, data_set|
      data_set.each do |line|
        collected[line[:timeframe].to_i] = collect_race_by_subject(race_data, race)
        end
      end
    collected
  end

  def collect_race_by_subject(race_data, race)
    collected = {}
    race_data.each do |type, data_set|
      data_set.each do |line|
        collected[type] = line[:data].to_f if sym_match?(line[:race_ethnicity], race)
        end
      end
    collected
  end



# Helper Methods

  def sym_match?(string, sym)
    string.downcase.gsub(' ', '_').to_sym == sym
  end

  def group_data_by(data_set, header)
    data_set.group_by { |line| line[header] }
  end
end
