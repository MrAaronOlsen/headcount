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
    grab_proficiency(@data[grades[grade]])
  rescue NoMethodError
    raise UnknownDataError.new('unknown grade')
  end

  def proficient_by_race_or_ethnicity(race)
    race_data = grab_race_ethnicity_data
    collect_race_by_date(race_data, race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    result = proficient_by_grade(grade)[year][subject]
    raise UnknownDataError.new if result.nil?
    result
  end

 def proficient_for_subject_by_race_in_year(subject, race, year)
    result = proficient_by_race_or_ethnicity(race)[year][subject]
    raise UnknownDataError.new if result.nil?
    result
  end

  def grab_proficiency(grade_data)
    grouped = group_data_by(grade_data, :timeframe)

    grouped.hash_map do |year, data|
      {year.to_i => data.hash_map do |line|
        { mk_sym(line[:score]) => scrub_data(line[:data]) }
      end }
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
        collected[line[:timeframe].to_i] = collect_race_by_subject(race_data, race, line[:timeframe])
        end
      end
    collected
  end

  def collect_race_by_subject(race_data, race, date)
    collected = {}
    race_data.each do |type, data_set|
      data_set.each do |line|
        if sym_match?(line[:race_ethnicity], race) && line[:timeframe] == date
          collected[type] = scrub_data(line[:data])
        end
      end
    end
    collected
  end

# Helper Methods

  def scrub_data(data)
    if data.to_f.to_s == data || data.to_i.to_s == data
      data.to_f
    else
      'N/A'
    end
  end

  def sym_match?(string, sym)
    mk_sym(string) == sym
  end

  def mk_sym(string)
    string.downcase.gsub(' ', '_').to_sym
  end

  def group_data_by(data_set, header)
    data_set.group_by { |line| line[header] }
  end
end
