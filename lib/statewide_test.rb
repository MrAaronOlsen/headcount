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
    grades = {3 => :third_grade, 8 => :eight_grade}
    unless grades[grade].nil?
      grab_proficiency(@data[grades[grade]], :timeframe)
    else
      "No Grade Found"
    end
  end

  def grab_proficiency(grade_data)
    grouped = group_data_by(grade_data, :timeframe)

    grouped.hash_map do |year, data|
      {year => data.hash_map { |line| { line[:score] => line[:data] } } }
    end
  end

  def proficient_by_race_or_ethnicity(race)
    collect_by_date(race)
  end

  def collect_by_date(race)
    parsed = {}
    @data_sets.each do |type, data_set|
      data_set.each do |line|
        parsed[line[:timeframe]] = collect_by_score(race)
        end
      end
    parsed
  end

  def collect_by_score(race)
    collected = {}
    @data_sets.each do |type, data_set|
      data_set.each do |line|
        collected[type] = line[:data] if line[:race_ethnicity].downcase.gsub(' ', '_').to_sym == race
        end
      end
    collected
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
  end

  def group_data_by(data_set, header)
    data_set.group_by { |line| line[header] }
  end
end
