require_relative 'unknown_data_error'
require_relative 'unknown_race_error'
require_relative 'headcount_helper'

class StatewideTest

  attr_reader :data

  def initialize(data)
    @data = data

  end

  def name

    @data[:name]
  end

  def proficient_by_grade(grade)
   if grade == 3
     grade_proficiency_process(@data[:third_grade])
   elsif grade == 8
     grade_proficiency_process(@data[:eight_grade])
   else
     "No Grade Found"
   end
  end

  def grade_proficiency_process(grade)
    grouped = scores_grouped_by_year(grade)
    parsed = {}
    grouped.each { |year, data| parsed[year] = hash_by_score(data) }
    parsed
  end

  def hash_by_score(year_data)
    merged = {}
    year_data.each { |line| merged[line[:score]] = line[:data] }
    merged
  end

  def scores_grouped_by_year(data)
    data.group_by { |line| line[:timeframe] }
  end

  def proficient_by_race_or_ethnicity(race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
  end

  def collect_data
    temp = {}
    @data.each do |line|
        temp[line[:timeframe].to_i] = collect_scores(data_set, line[:timeframe], name)
    end
    temp
  end

  def collect_scores(data_set, date, name)
    score_hash = {}
    data_set.each do |line|
      # binding.pry
      score_hash[line[:score].downcase.to_sym] = line[:data].to_f if line[:timeframe] == date && line[:location] == name
    end
    score_hash
  end
end
